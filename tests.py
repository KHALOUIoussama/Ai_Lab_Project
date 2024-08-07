import numpy as np
import utils


def cas1(df):
    # Create new columns that shift 'Echantillon' one row up and down
    df['Echantillon_shifted_up_status'] = df['variable_status'].shift(-1)
    df['Echantillon_shifted_down_status'] = df['variable_status'].shift(1)

    # Create 'Status' column based on the condition
    # les Batchs voisins des hors limites
    df['Status'] = np.where((df['Echantillon_shifted_up_status'].isin(['<', '>']) |
                             df['Echantillon_shifted_down_status'].isin(['<', '>'])),
                            'Retest_neighbor_HL',
                            '-')
    # les Batchs hors limites
    df['Status'] = np.where(df['variable_status'].isin(['<', '>']),
                            'Retest_HL',
                            df['Status'])

    return df


def cas2_3(df):
    if df.empty:
        return 0
    if df['MH_CV'][0] > 5:
        return 1
    elif df['MH_CV'][0] <= 5:
        return 2


def cas4(df):
    if df.empty:
        return 0
    if df['ML_different_des_autres'][0] == 'NON':
        if df['MH=ML'][0] == 'NON':
            return 1
        if df['MH=ML'][0] == 'OUI':
            return 2
        return 1
    return 0


def cas5(df):
    if df.empty:
        return 0
    if df['ML_different_des_autres'][0] == 'OUI':
        df_return = df[df['ML_different_des_autres'] == 'OUI']
        return df_return['Batch'], df_return['Palette']
    return 0


# On peut tolérer une courbe qui ne suit pas les autres
def cas6(df):
    # If 'Above Criteria Limit' does not exist, return 0
    if 'Above Criteria Limit' not in df['variable_status'].values:
        return 0

    # Check if 'Below Criteria Limit' exists only once, we can ignore it
    if (df['variable_status'] == 'Below Criteria Limit').sum() == 1:
        pass  # Ignore and proceed
    else:
        # If 'Below Criteria Limit' exists more than once, return 0
        if 'Below Criteria Limit' in df['variable_status'].values:
            return 0

    # Check if 'Passed Below Midpoint' exists only once, we can ignore it
    if (df['variable_status'] == 'Passed Below Midpoint').sum() == 1:
        pass  # Ignore and proceed
    else:
        # If 'Passed Below Midpoint' exists more than once, return 0
        if 'Passed Below Midpoint' in df['variable_status'].values:
            return 0

    # If none of the conditions above are met, return rows with 'Above Criteria Limit'
    return df[df['variable_status'] == 'Above Criteria Limit']


def cas7(df):
    if 'Below Criteria Limit' not in df['variable_status'].values:
        return 0

    # Check if 'Below Criteria Limit' exists only once, we can ignore it
    if (df['variable_status'] == 'Above Criteria Limit').sum() == 1:
        pass  # Ignore and proceed
    else:
        # If 'Above Criteria Limit' exists more than once, return 0
        if 'Above Criteria Limit' in df['variable_status'].values:
            return 0

    # Check if 'Passed Above Midpoint' exists only once, we can ignore it
    if (df['variable_status'] == 'Passed Above Midpoint').sum() == 1:
        pass  # Ignore and proceed
    else:
        # If 'Passed Below Midpoint' exists more than once, return 0
        if 'Passed Above Midpoint' in df['variable_status'].values:
            return 0

    # If none of the conditions above are met, return rows with 'Above Criteria Limit'
    return df[df['variable_status'] == 'Below Criteria Limit']


def casS(df):
    return utils.df_distance(utils.trim(utils.add_fitted_slope(utils.trim(df))))
