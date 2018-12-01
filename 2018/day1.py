import re
from abc import ABCMeta, abstractmethod
from typing import List


class Day(metaclass=ABCMeta):
    def __init__(self, input_as_string: str):
        self._input: str = input_as_string

    @abstractmethod
    def solve(self):
        """
        The result is simply the sum of all frequency changes.
        """
        pass


class Day1(Day):
    """
    After feeling like you've been falling for a few minutes, you look at the device's tiny screen. "Error: Device must be calibrated before first use. Frequency drift detected. Cannot maintain destination lock." Below the message, the device shows a sequence of changes in frequency (your puzzle input). A value like +6 means the current frequency increases by 6; a value like -3 means the current frequency decreases by 3.

    For example, if the device displays frequency changes of +1, -2, +3, +1, then starting from a frequency of zero, the following changes would occur:

    Current frequency  0, change of +1; resulting frequency  1.
    Current frequency  1, change of -2; resulting frequency -1.
    Current frequency -1, change of +3; resulting frequency  2.
    Current frequency  2, change of +1; resulting frequency  3.
    In this example, the resulting frequency is 3.

    Here are other example situations:

    +1, +1, +1 results in  3
    +1, +1, -2 results in  0
    -1, -2, -3 results in -6
    Starting with a frequency of zero, what is the resulting frequency after all of the changes in frequency have been applied?
    """

    def solve(self):
        """
        The result is simply the sum of all frequency changes.
        """
        changes = self._parse_changes()
        return sum(changes)

    def _parse_changes(self) -> List[int]:
        def all_changes():
            for line in self._input.splitlines():
                yield self._parse_line(line)

        return list(all_changes())

    @staticmethod
    def _parse_line(line) -> int:
        regex = re.compile(r'([+-])(\d+)')
        match = regex.match(line)

        sign = match.group(1)
        digit = int(match.group(2))

        if sign == '+':
            return digit
        elif sign == '-':
            return -digit
        else:
            raise ValueError("Parsing error!")
