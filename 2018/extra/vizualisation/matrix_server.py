import math
from flask import Flask, jsonify
app = Flask(__name__)


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


class MockMatrixGenerator():
    size = 20
    dimensions = (size, size)
    matrix = None
    point: Point = None

    def get_next_matrix(self):
        if self.matrix is None:
            self._initial_step()
        else:
            self._next_step()

        return self.matrix

    def reset_matrix(self):
        self.matrix = None


    def _initial_step(self):
        self.point = Point(math.floor(self.size/2), 0)
        max_x = self.dimensions[0]
        max_y = self.dimensions[1]
        self.matrix = [['' for x in range(max_x)] for y in range(max_y)]
        self._mark_point()

    def _next_step(self):
        self._clear_point()
        self.point.move_right(limit=self.size)
        self._mark_point()

    def _mark_point(self):
        self.matrix[self.point.x][self.point.y] = '1.'

    def _clear_point(self):
        self.matrix[self.point.x][self.point.y] = '1'


matrix_generator = MockMatrixGenerator()


@app.route("/matrix/next")
def next():
    new_mat = matrix_generator.get_next_matrix()
    return jsonify(new_mat)


@app.route("/matrix/reset")
def reset():
    matrix_generator.reset_matrix()
    return "Done"
