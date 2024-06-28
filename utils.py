import numpy as np
from scipy.cluster.hierarchy import linkage, fcluster
from sqlalchemy import text
from sqlalchemy.engine.url import URL
from sqlalchemy import create_engine
import pandas as pd


def add_slope(df):
    df['slope'] = df.groupby('ResultCurve_id').apply(lambda group: group['xvalue'].diff() / group['xtime'].diff(),
                                                     include_groups=False).reset_index(level=0, drop=True)
    return df


def add_fitted_slope(df):
    df['fitted_slope'] = np.nan

    for sample in df['Sample_Code'].unique():
        df_sample = df[df['Sample_Code'] == sample]

        z1 = np.polyfit(df_sample['xtime'], df_sample['slope'], 3)
        p1 = np.poly1d(z1)

        # Update the 'fitted_slope' in df_data for the current sample
        df.loc[df['Sample_Code'] == sample, 'fitted_slope'] = p1(df_sample['xtime'])

    return df


def setup(host, file_path):
    conn_url = URL.create(drivername='mssql+pyodbc',
                          host=host,
                          database='Enterprise',
                          query={
                              "driver": "ODBC Driver 17 for SQL Server",
                              "TrustServerCertificate": "yes",
                              "authentication": "ActiveDirectoryIntegrated"
                          }
                          )

    eng = create_engine(conn_url)
    eng.connect()

    with open(file_path, 'r') as file:
        sql_query = file.read()

    with eng.begin() as con:
        query = text(sql_query)
        df_data = add_fitted_slope(pd.read_sql_query(query, con))

    return df_data


def distance(df_order):
    max_slope_sample_xtime = \
        df_order.loc[df_order.groupby('Sample_Code')['fitted_slope'].idxmax()][['Batch', 'xtime']].set_index('Batch')[
            'xtime']

    values = np.array(max_slope_sample_xtime).reshape(-1, 1)
    # Générer les liens entre les clusters
    linked = linkage(values, 'ward')

    # Utiliser fcluster pour créer des clusters en fonction du nombre de clusters désiré
    clusters = fcluster(linked, 2, criterion='maxclust')

    # supprimer la valeur de values si elle est seul dans clusters
    counts = np.bincount(clusters)
    large_clusters = np.where(counts > 2)[0]
    values = values[np.isin(clusters, large_clusters)]

    linked = linkage(values, 'ward')
    dist = linked[-1, 2] - 0.2

    return dist


def df_distance(df):
    # Initialize an empty DataFrame to store the results
    df_results = pd.DataFrame(columns=['OrderNo', 'Distance'])

    if 'OrderNo' not in df.columns:
        dist = distance(df) * 100
        return dist

    for OrderNo in df['OrderNo'].unique():
        # Find the xtime corresponding to the max slope for each group
        df_order = df[df['OrderNo'] == OrderNo]

        dist = distance(df_order) * 100

        # Add the result to the DataFrame
        df_temp = pd.DataFrame({'OrderNo': [OrderNo], 'Distance': [dist]})

        df_results = pd.concat([df_results, df_temp], ignore_index=True)

        # Order by distance
        df_results = df_results.sort_values(by='Distance', ascending=False)
    return df_results


def trim(df, a, b):
    return df[(df['xtime'] >= a) & (df['xtime'] <= b)]
