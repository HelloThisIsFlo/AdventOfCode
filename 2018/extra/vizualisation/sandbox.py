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


COLOR_MAPPING = {
    '': [255, 255, 255],
    '1': [230, 181, 255],
    '1.': [183, 40, 255]
}


class MatrixGifGenerator:
    """
    Takes a Matrix server to generate multiple iteration of the matrix evolution and compile them in an animated GIF
    """

    _axes: matplotlib.axes.Axes
    _figure: matplotlib.figure.Figure
    _displayed_matrix: matplotlib.image.AxesImage

    def __init__(self, matrix_server: MatrixServer):
        self._matrix_server = matrix_server
        self._figure, self._axes = plt.subplots()
        self._initialize_matplotlib_axes()
        self._initialize_displayed_matrix()

    def generate_gif(self, filename, number_of_frames=10, update_interval=500):
        self._init_animation(number_of_frames, update_interval)
        self._generate_and_save_animation(filename)

    def _initialize_matplotlib_axes(self):
        self._axes.tick_params(axis='x',
                               top=True,
                               labeltop=True,
                               bottom=False,
                               labelbottom=False)

    def _initialize_displayed_matrix(self):
        self._matrix_server.reset_matrix()
        first_matrix = self._matrix_server.get_next_matrix()

        self._displayed_matrix = \
            self._axes.imshow(
                self._map_to_color_matrix(
                    first_matrix))

    def _map_to_color_matrix(self, matrix):
        color_matrix = matrix.copy()
        for y in range(len(matrix)):
            for x in range(len(matrix[y])):
                val = matrix[y][x]
                color_matrix[y][x] = COLOR_MAPPING[val]
        return color_matrix

    def _init_animation(self, number_of_frames, update_interval):
        def update(frame) -> None:
            if frame == 0:
                self._matrix_server.reset_matrix()

            self._displayed_matrix.set_data(
                self._map_to_color_matrix(
                    self._matrix_server.get_next_matrix()))

        self._animation = animation.FuncAnimation(self._figure,
                                                  update,
                                                  frames=number_of_frames,
                                                  repeat=False,
                                                  interval=update_interval)

    def _generate_and_save_animation(self, filename: str):
        if not filename.endswith('.gif'):
            raise ValueError("Ensure the filename has the '.gif' extension!")

        self._animation.save(filename, writer='imagemagick')


if __name__ == "__main__":
    gif_generator = MatrixGifGenerator(HttpMatrixServer())
    gif_generator.generate_gif('result.gif')