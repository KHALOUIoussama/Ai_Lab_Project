import matplotlib.pyplot as plt
import numpy as np
import matplotlib.patches as mpatches
import seaborn as sns


def dessiner_commande(df, degree=False):
    plt.figure(figsize=(20, 10))

    sns.set(style="whitegrid")

    if degree:
        for batch in df['Batch'].unique():
            df_batch = df[df['Batch'] == batch]
            df_batch = df_batch.sort_values(by='xtime')
            z = np.polyfit(df_batch['xtime'], df_batch['xvalue'], degree)
            p = np.poly1d(z)
            plt.plot(df_batch['xtime'], p(df_batch['xtime']))

    else:
        sns.lineplot(x='xtime', y='xvalue', hue='ResultCurve_id', data=df, legend=False)


def dessiner_sample(df, sample_code):
    # Filter the DataFrame
    df_sample = df[df['Sample_Code'] == sample_code]

    plt.figure(figsize=(20, 10))
    # Create a new figure
    sns.set(style="whitegrid")

    # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'ResultCurve_id'
    sns.lineplot(x='xtime', y='xvalue', hue='ResultCurve_id', data=df_sample, legend=False)


def dessiner_batch(df, batch):
    # Filter the DataFrame
    df_batch = df[df['Batch'] == batch]

    plt.figure(figsize=(20, 10))

    # Create a new figure
    sns.set(style="whitegrid")

    # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'Sample_Code'
    sns.lineplot(x='xtime', y='xvalue', hue='Sample_Code', data=df_batch, legend=True)


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


def dessiner_batchs(df, liste_batchs):
    plt.figure(figsize=(20, 10))

    # Create a new figure
    sns.set(style="whitegrid")

    # Define a list of colors or a seaborn color palette
    colors = sns.color_palette("hsv", len(liste_batchs))

    # Create a list to store the legend handles
    legend_handles = []

    # For each batch in the list
    for i, batch in enumerate(liste_batchs):
        # Filter the DataFrame
        df_batch = df[df['Batch'] == batch]

        # Use Seaborn's lineplot function to plot 'xtime' against 'xvalue' for each 'Sample_Code'
        # Remove the hue parameter and set the color manually
        for sample in df_batch['Sample_Code'].unique():
            df_sample = df_batch[df_batch['Sample_Code'] == sample]
            sns.lineplot(x='xtime', y='xvalue', data=df_sample, legend=False, color=colors[i])

        # Create a legend handle for the current batch
        legend_handles.append(mpatches.Patch(color=colors[i], label=batch))

    # Add the custom legend to the plot
    plt.legend(handles=legend_handles)


def dessiner_commande_slope(df, degree, unified=False):
    plt.figure(figsize=(20, 10))

    sns.set(style="whitegrid")
    if unified:
        for batch in df['Batch'].unique():
            df_batch = df[df['Batch'] == batch]
            sns.regplot(x='xtime', y='slope', data=df_batch, order=degree, ci=None, scatter=False)
    if not unified:
        for sample in df['Sample_Code'].unique():
            df_sample = df[df['Sample_Code'] == sample]
            sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)


def dessiner_sample_slope(df, sample_code, degree):
    df_sample = df[df['Sample_Code'] == sample_code]
    plt.figure(figsize=(20, 10))
    sns.set(style="whitegrid")

    sns.regplot(x='xtime', y='slope', data=df_sample, order=degree, ci=None, scatter=False)


def dessiner_batch_slope(df, batch,degree):
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


def dessiner_batchs_slope(df, liste_batchs,degree, unified=False):
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
