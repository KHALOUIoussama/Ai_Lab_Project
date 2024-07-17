import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches
import seaborn as sns
import pandas as pd


def dessiner_commande(df, degree=False, c_type=False, ptype=None):
    plt.figure(figsize=(20, 10))

    sns.set(style="whitegrid")


    if degree:
        for batch in df['Batch'].unique():
            df_batch = df[df['Batch'] == batch]
            df_batch = df_batch.sort_values(by='xtime')
            z = np.polyfit(df_batch['xtime'], df_batch['xvalue'], degree)
            p = np.poly1d(z)
            plt.plot(df_batch['xtime'], p(df_batch['xtime']))
    if c_type:

        # Generate x values
        x = np.linspace(df['xtime'].min(), df['xtime'].max(), 400)

        # Generate y values
        y = ptype(x)

        plt.plot(x, y, color='black', linewidth=2.5, linestyle='-')
    else:
        sns.lineplot(x='xtime', y='xvalue', hue='ResultCurve_id', data=df, legend=False)


def dessiner_commande_type(df, degree=None, ci=None):
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")

    sns.regplot(x='xtime', y='xvalue', data=df, order=degree, ci=ci, scatter=False)


def commande_type(df, degree=None):

    z1 = np.polyfit(df['xtime'], df['xvalue'], degree)
    p1 = np.poly1d(z1)

    return p1


def commande_slope_type(df, degree=None):

    # remove the nan values
    df_a = df.replace([np.inf, -np.inf], np.nan).dropna(subset=['slope'])

    z1 = np.polyfit(df_a['xtime'], df_a['slope'], degree)
    p1 = np.poly1d(z1)

    return p1


def dessiner_sample(df, sample_code):
    # Filter the DataFrame
    df_sample = df[df['Sample_Code'] == sample_code]

    plt.figure(figsize=(20, 10))
    # Create a new figure
    sns.set(style="whitegrid")

    # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'ResultCurve_id'
    sns.lineplot(x='xtime', y='xvalue', hue='ResultCurve_id', data=df_sample, legend=False)


def dessiner_batch(df, batch, c_type=False, ptype=None):
    # Filter the DataFrame
    df_batch = df[df['Batch'] == batch]

    plt.figure(figsize=(20, 10))

    # Create a new figure
    sns.set(style="whitegrid")

    # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'Sample_Code'
    sns.lineplot(x='xtime', y='xvalue', hue='Sample_Code', data=df_batch, legend=True)
    if c_type:

        # Generate x values
        x = np.linspace(df['xtime'].min(), df['xtime'].max(), 400)

        # Generate y values
        y = ptype(x)

        plt.plot(x, y, color='black')
        plt.show()


def dessiner_samples(df, liste_samples):
    plt.figure(figsize=(20, 10))

    # Create a new figure
    sns.set(style="whitegrid")

    # For each sample code in the list
    for sample in liste_samples:
        # Filter the DataFrame
        df_sample = df[df['Sample_Code'] == sample]

        # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'ResultCurve_id'
        sns.lineplot(x='xtime', y='xvalue', hue='ResultCurve_id', data=df_sample, legend=False)


def dessiner_batchs(df, liste_batchs, degree=None, unified=False, c_type=False):
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")
    colors = sns.color_palette("hsv", len(liste_batchs))
    legend_handles = []

    for i, batch in enumerate(liste_batchs):
        df_batch = df[df['Batch'] == batch]
        if unified:
            sns.regplot(x='xtime', y='xvalue', data=df_batch, order=degree, ci=None, scatter=False, color=colors[i])
            legend_handles.append(mpatches.Patch(color=colors[i], label=batch))
        else:
            for sample in df_batch['Sample_Code'].unique():
                df_sample = df_batch[df_batch['Sample_Code'] == sample]
                sns.regplot(x='xtime', y='xvalue', data=df_sample, order=degree, ci=None, scatter=False,
                            color=colors[i])
                legend_handles.append(mpatches.Patch(color=colors[i], label=sample))
    if c_type:
        sns.regplot(x='xtime', y='xvalue', data=df, order=degree, ci=None, scatter=False, color='black')

    plt.legend(handles=legend_handles)


def dessiner_commande_slope(df, degree, unified=False, c_type=False, p_slope_type=None):
    plt.figure(figsize=(20, 10))

    sns.set(style="whitegrid")

    if unified:
        for batch in df['Batch'].unique():
            df_batch = df[df['Batch'] == batch]
            if degree == -1:
                sns.regplot(x='xtime', y='slope', data=df_batch, ci=None, scatter=False)
            else:
                sns.regplot(x='xtime', y='slope', data=df_batch, order=degree, ci=None, scatter=False)
    if not unified:
        for sample in df['Sample_Code'].unique():
            df_sample = df[df['Sample_Code'] == sample]
            if degree == -1:
                sns.regplot(x='xtime', y='slope', data=df_sample, ci=None, scatter=False)
            else:
                sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)
    if c_type:

        # Generate x values
        x = np.linspace(df['xtime'].min(), df['xtime'].max(), 400)

        # Generate y values
        y = p_slope_type(x)

        plt.plot(x, y, color='black', linewidth=2.5, linestyle='-')

def dessiner_commande_slope_type(df, degree=None, ci=None):
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")

    df_a = df.replace([np.inf, -np.inf], np.nan).dropna(subset=['slope'])

    sns.regplot(x='xtime', y='slope', data=df_a, order=degree, ci=ci, scatter=False)



def dessiner_sample_slope(df, sample_code, degree):
    df_sample = df[df['Sample_Code'] == sample_code]
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")

    sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)


def dessiner_batch_slope(df, batch, degree):
    df_batch = df[df['Batch'] == batch]
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")
    for sample in df_batch['Sample_Code'].unique():
        df_sample = df_batch[df_batch['Sample_Code'] == sample]
        sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)


def dessiner_samples_slope(df, liste_samples, degree):
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")
    for sample in liste_samples:
        df_sample = df[df['Sample_Code'] == sample]
        sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)


def dessiner_batchs_slope(df, liste_batchs, degree, unified=False):
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")
    colors = sns.color_palette("hsv", len(liste_batchs))
    legend_handles = []
    for i, batch in enumerate(liste_batchs):
        df_batch = df[df['Batch'] == batch]
        if not unified:
            for sample in df_batch['Sample_Code'].unique():
                df_sample = df_batch[df_batch['Sample_Code'] == sample]
                sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False, color=colors[i])
        if unified:
            sns.regplot(x='xtime', y='slope', data=df_batch, order=degree, ci=None, scatter=False, color=colors[i])
        legend_handles.append(mpatches.Patch(color=colors[i], label=batch))
    plt.legend(handles=legend_handles)


def visualiser_batch_pvalue(batch_pvalues, log=False):
    # Afficher les sommes des p-values pour chaque batch dans l'ordre décroissant
    for batch, pvalue_sum in sorted(batch_pvalues.items(), key=lambda x: x[1]):
        if log:
            print(f'- Batch {batch}: {-np.log(pvalue_sum)}')
        else:
            print(f'- Batch {batch}: {pvalue_sum}')
    # Convertir le dictionnaire en DataFrame
    df_pvalues = pd.DataFrame(list(batch_pvalues.items()), columns=['Batch', 'pvalue_sum'])

    # Trier le DataFrame par 'pvalue_sum'
    if log:
        df_pvalues['pvalue_sum'] = -np.log(df_pvalues['pvalue_sum'])

    df_pvalues = df_pvalues.sort_values(by='pvalue_sum')

    # Créer un histogramme
    plt.figure(figsize=(10, 5))
    plt.barh(df_pvalues['Batch'], df_pvalues['pvalue_sum'])
    plt.xlabel('P-value Test')
    plt.ylabel('Batch')
    plt.title('Sum of p-values for each Batch')
    plt.show()


def visualiser_sample_pvalue(sample_pvalues, log=False):
    # Afficher les sommes des p-values pour chaque batch dans l'ordre décroissant
    for sample, pvalue_sum in sorted(sample_pvalues.items(), key=lambda x: x[1]):
        if log:
            print(f'- Sample {sample}: {-np.log(pvalue_sum)}')
        else:
            print(f'- Sample {sample}: {pvalue_sum}')

    # Convertir le dictionnaire en DataFrame
    df_pvalues = pd.DataFrame(list(sample_pvalues.items()), columns=['Batch', 'pvalue_sum'])

    # Trier le DataFrame par 'pvalue_sum'
    if log:
        df_pvalues['pvalue_sum'] = -np.log(df_pvalues['pvalue_sum'])

    df_pvalues = df_pvalues.sort_values(by='pvalue_sum')

    # Créer un histogramme
    plt.figure(figsize=(10, 5))
    plt.barh(df_pvalues['Batch'], df_pvalues['pvalue_sum'])
    plt.xlabel('Sum of p-values')
    plt.ylabel('Batch')
    plt.title('Sum of p-values for each Batch')
    plt.show()
