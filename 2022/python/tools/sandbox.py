import numpy as np
import pandas as pd

import matplotlib as mpl
import matplotlib.pyplot as plt

import seaborn as sns
import seaborn.objects as so

from math import inf

if __name__ == "__main__":
    df = sns.load_dataset("glue")
    df = pd.DataFrame(
        [
            [2, 4, 6],
            [9, 1, 3],
            [-inf, 8, 0],
        ]
    )
    df = pd.DataFrame(
        [
            [True, False, True],
            [False, False, True],
            [True, False, False],
        ]
    )
    print(df)
    sns.heatmap(df, annot=True, vmin=0)
    plt.show()
    exit(0)
