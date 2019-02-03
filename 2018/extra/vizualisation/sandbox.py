from abc import ABC, abstractmethod
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
import matplotlib.animation as animation
import matplotlib
from typing import NamedTuple
import math
import requests


BASE_URL = "http://127.0.0.1:5000"


class MatrixServer(ABC):
    @abstractmethod
    def get_next_matrix(self):
        pass

    @abstractmethod
    def reset_matrix(self):
        pass


class HttpMatrixServer(MatrixServer):
    def get_next_matrix(self):
        return requests.get(BASE_URL + "/matrix/next").json()

    def reset_matrix(self):
        requests.get(BASE_URL + "/matrix/reset")


class MockMatrixServer(MatrixServer):

    def __init__(self):
        from matrix_server import MockMatrixGenerator
        self.generator = MockMatrixGenerator()

    def get_next_matrix(self):
        return self.generator.get_next_matrix()

    def reset_matrix(self):
        return self.generator.reset_matrix()


class Plot:
    _axes: matplotlib.axes.Axes
    _figure: matplotlib.figure.Figure
    _displayed_matrix: matplotlib.image.AxesImage
    _animation: animation.FuncAnimation

    _matrix_server: MatrixServer

    def __init__(self, save_gif=False):
        # self._matrix_server = MockMatrixServer()
        self._matrix_server = HttpMatrixServer()
        self._figure, self._axes = plt.subplots()
        self._init_axes_and_displayed_matrix()
        self._init_animation()
        self._save_gif = save_gif

    def _init_axes_and_displayed_matrix(self):
        self._displayed_matrix = self._axes.matshow(
            self._matrix_server.get_next_matrix())
        self._displayed_matrix.norm.vmin = 0
        self._displayed_matrix.norm.vmax = 1

    def _init_animation(self):
        def update(frame) -> None:
            if frame == 0:
                self._matrix_server.reset_matrix()

            new_matrix = self._matrix_server.get_next_matrix()
            self._displayed_matrix.set_data(new_matrix)

        self._animation = animation.FuncAnimation(self._figure,
                                                  update,
                                                  frames=10,
                                                  repeat=False,
                                                  interval=10)
        if self._save_gif:
            self._animation.save('result.gif', writer='imagemagick')

    def show(self):
        plt.show()


if __name__ == "__main__":
    # image = mpimg.imread('cat.png')
    # print(type(image))

    plot = Plot()
    plot.show()
