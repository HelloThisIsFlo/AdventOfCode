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

INFINITE = 10000000000000000


class Drone:
    def __init__(self):
        self.relative_position = Coordinates(0, 0)
        self.visited_relative_positions = [self.relative_position]
        self.performed_moves = []

    def _move_and_update_relative_position(self, direction, record_move=True):
        def update_relative_position():
            if direction == 'N':
                self.relative_position = Coordinates(
                    self.relative_position.x,
                    self.relative_position.y - 1,
                )
            elif direction == 'S':
                self.relative_position = Coordinates(
                    self.relative_position.x,
                    self.relative_position.y + 1,
                )
            elif direction == 'W':
                self.relative_position = Coordinates(
                    self.relative_position.x - 1,
                    self.relative_position.y,
                )
            elif direction == 'E':
                self.relative_position = Coordinates(
                    self.relative_position.x + 1,
                    self.relative_position.y,
                )

        status = self._move(direction)
        if status != DIDNT_MOVE:
            update_relative_position()
            performed_move = direction
        else:
            performed_move = None

        if record_move:
            self.performed_moves.append(performed_move)

        return status

    def north(self):
        return self._move_and_update_relative_position('N')

    def south(self):
        return self._move_and_update_relative_position('S')

    def west(self):
        return self._move_and_update_relative_position('W')

    def east(self):
        return self._move_and_update_relative_position('E')

    def revert_last_move(self):
        if not self.performed_moves:
            return

        last_performed_move = self.performed_moves.pop()
        if last_performed_move is None:
            pass
        elif last_performed_move == 'N':
            self._move_and_update_relative_position('S', record_move=False)
        elif last_performed_move == 'S':
            self._move_and_update_relative_position('N', record_move=False)
        elif last_performed_move == 'W':
            self._move_and_update_relative_position('E', record_move=False)
        elif last_performed_move == 'E':
            self._move_and_update_relative_position('W', record_move=False)

    def shortest_distance_to_oxygen(self):
        def shortest_distance_when_trying(direction):
            def already_visited_current_position():
                return self.relative_position in self.visited_relative_positions

            status = self._move_and_update_relative_position(direction)

            if status == DIDNT_MOVE:
                distance_when_going_this_direction = INFINITE

            elif status == MOVED_AND_FOUND_OXYGEN:
                distance_when_going_this_direction = len(
                    self.visited_relative_positions
                )
                distance_when_going_this_direction = 1

            elif status == MOVED and already_visited_current_position():
                distance_when_going_this_direction = INFINITE

            elif status == MOVED and not already_visited_current_position():
                self.visited_relative_positions.append(
                    self.relative_position
                )
                distance_when_going_this_direction = self.shortest_distance_to_oxygen() + 1
                self.visited_relative_positions.pop()

            else:
                raise ValueError('Should not end up here')

            self.revert_last_move()
            return distance_when_going_this_direction

        dist_when_going_north = shortest_distance_when_trying('N')
        dist_when_going_south = shortest_distance_when_trying('S')
        dist_when_going_west = shortest_distance_when_trying('W')
        dist_when_going_east = shortest_distance_when_trying('E')

        return min(
            dist_when_going_north,
            dist_when_going_south,
            dist_when_going_west,
            dist_when_going_east,
        )


class Coordinates(NamedTuple):
    x: int
    y: int

    def __repr__(self):
        return f'({self.x},{self.y})'


class MazeDrone(Drone):
    def __init__(self, maze):
        def find_coordinates_of(maze_val):
            for x in range(self.maze_width):
                for y in range(self.maze_height):
                    if maze[y][x] == maze_val:
                        return Coordinates(x, y)
            raise ValueError("Coordinates for {maze_val} couldn't be found!")

        super().__init__()
        self.maze = maze
        self.maze_width = len(maze[0])
        self.maze_height = len(maze)
        self.position = find_coordinates_of(MAZE_DRONE)
        self.oxygen_location = find_coordinates_of(MAZE_OXYGEN)

    def _move(self, direction):
        def valid_position(coord):
            def out_of_bounds():
                return (
                    coord.x not in range(self.maze_width)
                    or coord.y not in range(self.maze_height)
                )

            def is_wall():
                return self.maze[coord.y][coord.x] == MAZE_WALL

            return not out_of_bounds() and not is_wall()

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


class IntcodeDrone(Drone):
    def __init__(self, intcode):
        super().__init__()
        self.program = Program(intcode)
        self.program.run(capture_output=True)

    def _move(self, direction):
        def move_cmd():
            if direction == 'N':
                return 1
            if direction == 'S':
                return 2
            if direction == 'W':
                return 3
            if direction == 'E':
                return 4

        self.program.input(move_cmd())
        return self.program.runtime.captured_output[-1]


class Day15(IntcodeDay):
    def droid_program(self, hard_coded_input=None):
        if hard_coded_input:
            return Program(self.intcode, hard_coded_input=hard_coded_input)
        else:
            return Program(self.intcode)

    def solve_part_1(self):
        drone = IntcodeDrone(self.intcode)
        return str(
            drone.shortest_distance_to_oxygen()
        )

    def solve_part_2(self):
        pass
