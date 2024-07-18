from matplotlib import pyplot as plt
from scipy.cluster.hierarchy import linkage, fcluster
from sqlalchemy import text
from sqlalchemy.engine.url import URL
from sqlalchemy import create_engine
import pandas as pd
from tests import *
import seaborn as sns


def setup(host, file_path, do_trim):
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
        if do_trim:
            df_data = add_fitted_slope(trim(pd.read_sql_query(query, con)))
        else:
            df_data = add_fitted_slope(pd.read_sql_query(query, con))

    return df_data


def add_fitted_slope(df):
    for sample in df['Sample_Code'].unique():
        df_sample = df[df['Sample_Code'] == sample]

        z1 = np.polyfit(df_sample['xtime'], df_sample['slope'], 3)
        p1 = np.poly1d(z1)

        # Update the 'fitted_slope' in df_data for the current sample
        df.loc[df['Sample_Code'] == sample, 'fitted_slope'] = p1(df_sample['xtime'])

    return df


def read_and_replace(filename, OrderNo):
    with open(filename, 'r') as file:
        return text(file.read().replace('@OrderNo', OrderNo))


def execute_tests(host, OrderNo):
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

    with eng.begin() as con:

        test_Nb_Mdr = pd.read_sql_query(read_and_replace('Nb_Mdr.sql', OrderNo), con)['nb_instruments'][0]
        if test_Nb_Mdr > 1:
            print('Warning : Testé sur ' + str(test_Nb_Mdr) + ' MDRs\n')

        test_TMA = pd.read_sql_query(read_and_replace('TMA.sql', OrderNo), con)

        if not test_TMA.empty:
            print('!!!!!!!!!!!!!!!!!!! TMA !!!!!!!!!!!!!!!!!!!!\n')

        print('-----------------Cas1-----------------------')

        query1 = pd.read_sql_query(read_and_replace('Cas1.sql', OrderNo), con)
        test1 = cas1(query1)
        # Cas 1
        if test1.empty or test1['variable_status'].eq('Passed').all():
            print('Rien à Signaler')

        elif not test1.empty:
            retest_HL = test1[test1['Status'] == 'Retest_HL']['Batch'].drop_duplicates()
            retest_NHL = test1[test1['Status'] == 'Retest_neighbor_HL']['Batch'].drop_duplicates()
            retest_NHL = retest_NHL[~retest_NHL.isin(retest_HL)]

            df_pire = pd.read_sql_query(read_and_replace('Cas1_Pire.sql', OrderNo), con)

            for i in range(len(retest_HL)):
                print(f'Retester la Palette Hors Norme {retest_HL.iloc[i]}')

            for i in range(len(retest_NHL)):
                print(f'Retester la Palette Voisine {retest_NHL.iloc[i]}')

            if not df_pire.empty:
                print(f'--> la *Pire* Palette : {df_pire.iloc[0]["Batch"]}')

        print('-----------------Cas2&3---------------------')

        query2_3 = pd.read_sql_query(read_and_replace('Cas2_3.sql', OrderNo), con)
        test2_3 = cas2_3(query2_3)
        if test2_3 == 0:
            print('Rien à signaler')
        else:
            if test2_3 == 1:
                print('Remélange seul')
            elif test2_3 == 2:
                print('Faire retests')

        print('-----------------Cas4-----------------------')
        query4_5 = pd.read_sql_query(read_and_replace('Cas4_5.sql', OrderNo), con)
        test4 = cas4(query4_5)

        if test4 == 0:
            print('Rien à signaler')
        elif test4 == 1:
            print('Possiblité de SOFT CURE')
            print('Retest ou suivre cas n°5')
        elif test4 == 2:
            print('Possibilité de NO CURE')

        print('-----------------Cas5-----------------------')
        test5 = cas5(query4_5)

        if test5 == 0:
            print('Rien à signaler')
        else:
            for i in range(test5[0].shape[0]):
                print('Échantillon étranger ' + str(test5[1][i]) + ' de la Palette ' + str(test5[0][i]))
                print('Aviser le superviseur du 1A pour Ré-échantillonner la platte')

        print('-----------------Cas6-----------------------')
        query6_7 = pd.read_sql_query(read_and_replace('Cas6_7_Criteria.sql', OrderNo), con)
        test6 = cas6(query6_7)

        # Cas 6
        if isinstance(test6, pd.DataFrame):
            for i in range(len(test6)):
                print(
                    f'Cas 6 : Envoyer l\'Échantillon {test6.iloc[i]['Palette']} de la Palette {test6.iloc[i]['Batch']} en '
                    f'REMILL')
            print('Envoyer E-mail à JL-PLT Intervention pour les aviser')

        elif test6 == 0:
            print('Rien à Signaler')

        print('-----------------Cas7-----------------------')
        test7 = cas7(query6_7)

        # Cas 7
        if isinstance(test7, pd.DataFrame):
            for i in range(len(test7)):
                print(
                    f'Cas 7 : Envoyer l\'échantillon {test7.iloc[i]['Palette']} de la Palette {test7.iloc[i]['Batch']} en '
                    f'REMILL')
            print('Envoyer E-mail à JL-PLT Intervention pour les aviser')

        elif test7 == 0:
            print('Rien à Signaler')

        queryS = pd.read_sql_query(read_and_replace('Cas_special.sql', OrderNo), con)
        queryS_prime = utils.trim(utils.add_fitted_slope(utils.trim(queryS)))

        if host == r'sql1djol\mel':
            sns.lineplot(x='xtime', y='xvalue', hue='Sample_Code', data=queryS, legend=False)

        testS = utils.df_distance(queryS_prime)
        test_S_score = testS[0]

        # Cas Special
        if test_S_score > 8:
            print('--------------Cas Croisement----------------')
            sns.lineplot(x='xtime', y='fitted_slope', hue='Sample_Code', data=queryS_prime, legend=False)
            print('*Très Grand* Risque de croisement de courbes avec score : ' + str(test_S_score))
            return testS[1]

        # Cas Special
        if test_S_score > 1:
            print('--------------Cas Croisement----------------')
            sns.lineplot(x='xtime', y='fitted_slope', hue='Sample_Code', data=queryS_prime, legend=False)
            print('Risque de croisement de courbes avec score : ' + str(test_S_score))
            return testS[1]


def distance(df_order):
    max_slope_sample_xtime = \
        df_order.loc[df_order.groupby('Sample_Code')['fitted_slope'].idxmax()][
            ['Palette', 'Echantillon', 'xtime']].reset_index(drop=True)

    values = np.array(max_slope_sample_xtime['xtime']).reshape(-1, 1)
    # Générer les liens entre les clusters
    linked = linkage(values, 'ward')

    # Utiliser fcluster pour créer des clusters en fonction du nombre de clusters désiré
    initial_clusters = fcluster(linked, 2, criterion='maxclust')

    # supprimer la valeur de values si elle est seul dans clusters
    counts = np.bincount(initial_clusters)
    large_clusters = np.where(counts > 1)[0]
    values = values[np.isin(initial_clusters, large_clusters)]

    linked = linkage(values, 'ward')
    if linked is None:
        return 0

    # Créer un tableau clusters de la même longueur que values initialisé avec des zéros
    clusters = np.zeros_like(initial_clusters)
    # Remplacer les valeurs correspondant aux grands clusters par les résultats de fcluster
    clusters[np.isin(initial_clusters, large_clusters)] = fcluster(linked, 2, criterion='maxclust')

    # Ajouter les clusters au DataFrame max_slope_sample_xtime
    max_slope_sample_xtime['Cluster'] = clusters

    dist = (linked[-1, 2] - 0.22) * 100

    return dist, max_slope_sample_xtime[['Palette', 'Echantillon', 'Cluster']]


def df_distance(df):
    # Initialize an empty DataFrame to store the results
    df_results = pd.DataFrame(columns=['OrderNo', 'Distance'])

    if 'OrderNo' not in df.columns:
        return distance(df)

    for OrderNo in df['OrderNo'].unique():
        # Find the xtime corresponding to the max slope for each group
        df_order = df[df['OrderNo'] == OrderNo]

        dist = distance(df_order)[0]

        df_results = pd.concat([df_results, pd.DataFrame({'OrderNo': [OrderNo], 'Distance': [dist]})],
                               ignore_index=True)

    return df_results


def trim(df):
    return df[(df['xtime'] >= 0.2) & (df['xtime'] <= 0.8)]


def debug_tests(host, OrderNo):
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

    with eng.begin() as con:

        queryS = pd.read_sql_query(read_and_replace('Cas_special.sql', OrderNo), con)
        queryS_prime = utils.trim(utils.add_fitted_slope(utils.trim(queryS)))

        plt.figure()
        sns.lineplot(x='xtime', y='xvalue', hue='Sample_Code', data=queryS, legend=False)
        plt.figure()
        sns.lineplot(x='xtime', y='fitted_slope', hue='Sample_Code', data=queryS_prime, legend=False)

        testS = utils.df_distance(queryS_prime)
        test_S_score = testS[0]

        print(test_S_score)
        return testS[1]
