import abc
import re
from math import floor, inf

from days.day import Day
from abc import ABC, abstractmethod


def parse_direction(line):
    regex = re.search(r'(\w+) (\d+)', line)
    direction = regex.group(1)
    count = regex.group(2)
    return Direction.from_str(direction, int(count), False)


def parse_aim_direction(line):
    regex = re.search(r'(\w+) (\d+)', line)
    direction = regex.group(1)
    count = regex.group(2)
    return Direction.from_str(direction, int(count), True)


class Day2(Day):
    def solve_part_1(self):
        return self.solve_with_parsing_func(parse_direction)

    def solve_part_2(self):
        return self.solve_with_parsing_func(parse_aim_direction)

    def solve_with_parsing_func(self, parsing_func):
        submarine = Submarine()
        directions = self.input_lines(parsing_func)

        for d in directions:
            d.apply(submarine)

        return str(submarine.x * submarine.y)


class Submarine:
    def __init__(self):
        self.x = 0
        self.y = 0
        self.aim = 0

    def move(self, direction: 'Direction'):
        direction.apply(self)


class Direction(ABC):
    def __init__(self, count):
        self.count = count

    def apply(self, submarine: Submarine):
        for _ in range(self.count):
            self._do_apply(submarine)

    @abstractmethod
    def _do_apply(self, submarine: Submarine):
        pass

    @staticmethod
    def from_str(dir_as_str, count, aim_mode):
        if aim_mode:
            if 'forward' in dir_as_str:
                return ForwardAim(count)
            elif 'up' in dir_as_str:
                return UpAim(count)
            elif 'down' in dir_as_str:
                return DownAim(count)
            else:
                raise RuntimeError()
        else:
            if 'forward' in dir_as_str:
                return Forward(count)
            elif 'up' in dir_as_str:
                return Up(count)
            elif 'down' in dir_as_str:
                return Down(count)
            else:
                raise RuntimeError()


class Forward(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.x += 1


class Down(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.y += 1


class Up(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.y -= 1


class ForwardAim(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.x += 1
        submarine.y += (1 * submarine.aim)


class DownAim(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.aim += 1


class UpAim(Direction):
    def _do_apply(self, submarine: Submarine):
        submarine.aim -= 1
