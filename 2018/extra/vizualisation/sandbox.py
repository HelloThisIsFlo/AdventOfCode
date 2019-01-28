import matplotlib.pyplot as plt
import matplotlib
import numpy as np


def main():
    zeros = np.zeros((20, 20))
    print(zeros)


class Plot:
    dimensions = (20, 20)
    matrix = None

    def __init__(self):
        self._build_matrix()

    def _build_matrix(self):
        self.matrix = np.zeros(self.dimensions)
        for i in range(min(self.dimensions)):
            self.matrix[i, i] = i

    def show(self):
        ax: matplotlib.axes.Axes
        # ax.matshow()
        # plt.matshow(self.matrix)
        plt.imshow(self.matrix)
        plt.show()


if __name__ == "__main__":
    plot = Plot()

    plot.show()

    # image = matplotlib.image.imread('cat.png')
    # plt.imshow(image)
    # print(image)
    # plt.show()