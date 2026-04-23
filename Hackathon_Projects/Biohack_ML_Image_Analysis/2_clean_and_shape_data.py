from scipy import stats
import pandas as pd
import numpy as np

df = pd.read_csv('features.csv')

# find numeric columns
n_rows = df.index  # row length
num_cols = df.select_dtypes(include=['number']).columns   # gives column names
outlier_info = {}

# find outliers in each column
for col in num_cols:

    z_col = stats.zscore(df[col])
    mask = np.abs(z_col) > 3

    outlier_info[col] = {
        'indices': df[mask].index.tolist(),
        'original_values': df.loc[mask, col].round(2).tolist(),
        'z_scores': z_col[mask].round(2).tolist()
    }

    count = len(outlier_info[col]['indices'])

    if count > 0:
        print(f"\n{count} outliers in {col}:")
        for idx, val, z in zip(outlier_info[col]['indices'],
                                outlier_info[col]['original_values'],
                                outlier_info[col]['z_scores']):
            print(f"  Index {idx}: value={val}, z-score={z}")


# compile outlier row indices
outlier_rows = []

for col in num_cols:
    for key, values in outlier_info[col].items():
        if key == "indices":
            outlier_rows.extend(values)

# find unique values
outlier_rows = list(set(outlier_rows))

# delete outliers
df = df.drop(outlier_rows)

# upload data to csv
df.to_csv('clean_features.csv', index=False)