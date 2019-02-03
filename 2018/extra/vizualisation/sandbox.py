import matplotlib.pyplot as plt
import matplotlib.animation as animation
import matplotlib
import numpy as np
from typing import NamedTuple
import math


def main():
    zeros = np.zeros((20, 20))
    print(zeros)


class Point:
    x: int
    y: int

    def __init__(self, x, y):
        self.x = x
        self.y = y

    def move_right(self, limit=None):
        new_y = self.y + 1
        if limit and new_y >= limit:
            new_y = 0
        self.y = new_y

from abc import ABC, abstractmethod

class MatrixServer(ABC):
    @abstractmethod
    def get_new_matrix(self):
        pass

    @abstractmethod
    def reset_matrix(self):
        pass


class MockMatrixServer(MatrixServer):
    size = 20
    dimensions = (size, size)
    matrix = None
    point: Point = Point(math.floor(size/2), 0)

    def get_new_matrix(self):
        if self.matrix is None:
            self._initial_step()
        else:
            self._next_step()

        return self.matrix

    def reset_matrix(self):
        self.matrix = None

    def _initial_step(self):
        self.matrix = np.zeros(self.dimensions)
        self._mark_point()

    def _next_step(self):
        self._clear_point()
        self.point.move_right(limit=self.size)
        self._mark_point()

    def _mark_point(self):
        self.matrix[self.point.x, self.point.y] = 1

    def _clear_point(self):
        self.matrix[self.point.x, self.point.y] = 0


class Plot:
    _axes: matplotlib.axes.Axes
    _figure: matplotlib.figure.Figure
    _displayed_matrix: matplotlib.image.AxesImage
    _animation: animation.FuncAnimation

    _matrix_server: MatrixServer

    def __init__(self):
        self._matrix_server = MockMatrixServer()
        self._figure, self._axes = plt.subplots()
        self._init_axes_and_displayed_matrix()
        self._init_animation()

    def _init_axes_and_displayed_matrix(self):
        self._displayed_matrix = self._axes.matshow(self._matrix_server.get_new_matrix())
        self._displayed_matrix.norm.vmin = 0
        self._displayed_matrix.norm.vmax = 1

    def _init_animation(self):
        def update(frame) -> None:
            if frame == 0:
                self._matrix_server.reset_matrix()

            new_matrix = self._matrix_server.get_new_matrix()
            self._displayed_matrix.set_data(new_matrix)

        self._animation = animation.FuncAnimation(self._figure,
                                                  update,
                                                  interval=100)

    def show(self):
        plt.show()


if __name__ == "__main__":
    plot = Plot()
    plot.show()
