from base import IntcodeDay
from computer import Program
from typing import NamedTuple

MAZE_DRONE = 8
MAZE_OXYGEN = 9
MAZE_FREE = 0
MAZE_WALL = 1

DIDNT_MOVE = 0
MOVED = 1
MOVED_AND_FOUND_OXYGEN = 2


class Drone:
    def north(self):
        raise NotImplementedError()

    def south(self):
        raise NotImplementedError()

    def west(self):
        raise NotImplementedError()

    def east(self):
        raise NotImplementedError()


class Coordinates(NamedTuple):
    x: int
    y: int


class MazeDrone(Drone):
    def __init__(self, maze):
        def find_coordinates_of(maze_val):
            for x in range(self.maze_width):
                for y in range(self.maze_height):
                    if maze[y][x] == maze_val:
                        return Coordinates(x, y)
            raise ValueError("Coordinates for {maze_val} couldn't be found!")

        self.maze = maze
        self.maze_width = len(maze[0])
        self.maze_height = len(maze)
        self.position = find_coordinates_of(MAZE_DRONE)
        self.oxygen_location = find_coordinates_of(MAZE_OXYGEN)

    def _move(self, direction):
        def valid_position(coord):
            out_of_bounds = (
                coord.x not in range(self.maze_width)
                or coord.y not in range(self.maze_height)
            )
            is_wall = self.maze[coord.y][coord.x] == MAZE_WALL
            return not out_of_bounds and not is_wall

        if direction == 'N':
            candidate_position = Coordinates(
                self.position.x,
                self.position.y - 1
            )
        elif direction == 'S':
            candidate_position = Coordinates(
                self.position.x,
                self.position.y + 1
            )
        elif direction == 'W':
            candidate_position = Coordinates(
                self.position.x - 1,
                self.position.y
            )
        elif direction == 'E':
            candidate_position = Coordinates(
                self.position.x + 1,
                self.position.y
            )

        if not valid_position(candidate_position):
            return DIDNT_MOVE

        self.position = candidate_position
        if self.position == self.oxygen_location:
            return MOVED_AND_FOUND_OXYGEN
        else:
            return MOVED

    def north(self):
        return self._move('N')

    def south(self):
        return self._move('S')

    def west(self):
        return self._move('W')

    def east(self):
        return self._move('E')


class IntcodeDrone(Drone):
    def __init__(self, intcode):
        self.program = Program(intcode)
        self.program.run(capture_output=True)

    def _move(self, move_cmd):
        self.program.input(move_cmd)
        return self.program.runtime.captured_output[-1]

    def north(self):
        return self._move(1)

    def south(self):
        return self._move(2)

    def west(self):
        return self._move(3)

    def east(self):
        return self._move(4)


class Day15(IntcodeDay):
    def droid_program(self, hard_coded_input=None):
        if hard_coded_input:
            return Program(self.intcode, hard_coded_input=hard_coded_input)
        else:
            return Program(self.intcode)

    def solve_part_1(self):
        pass

    def solve_part_2(self):
        pass
