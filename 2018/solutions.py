import itertools
import re
from abc import ABCMeta, abstractmethod


class Day(metaclass=ABCMeta):
    def __init__(self, input_as_string: str):
        self._input: str = input_as_string

    @abstractmethod
    def solve_part_1(self):
        pass

    @abstractmethod
    def solve_part_2(self):
        pass


class Day1(Day):
    """
    --- Part One ---
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



    --- Part Two ---
    You notice that the device repeats the same frequency change list over and over. To calibrate the device, you need to find the first frequency it reaches twice.

    For example, using the same list of changes above, the device would loop as follows:

    Current frequency  0, change of +1; resulting frequency  1.
    Current frequency  1, change of -2; resulting frequency -1.
    Current frequency -1, change of +3; resulting frequency  2.
    Current frequency  2, change of +1; resulting frequency  3.
    (At this point, the device continues from the start of the list.)
    Current frequency  3, change of +1; resulting frequency  4.
    Current frequency  4, change of -2; resulting frequency  2, which has already been seen.
    In this example, the first frequency reached twice is 2. Note that your device might need to repeat its list of frequency changes many times before a duplicate frequency is found, and that duplicates might be found while in the middle of processing the list.

    Here are other examples:

    +1, -1 first reaches 0 twice.
    +3, +3, +4, -2, -4 first reaches 10 twice.
    -6, +3, +8, +5, -6 first reaches 5 twice.
    +7, +7, -2, -7, -4 first reaches 14 twice.
    What is the first frequency your device reaches twice?
    """

    def __init__(self, input_as_string: str):
        super().__init__(input_as_string)

        self.initial_freq = 0
        self.traversed_frequencies = {self.initial_freq}
        self.changes = []

    def solve_part_1(self):
        """
        The result is simply the sum of all frequency changes.
        """
        self._parse_changes()
        return sum(self.changes)

    def solve_part_2(self):
        """
        While probably not the most optimized solution a simple implementation would be to
        keep track of all traversed frequencies, and each time a new frequency is reached,
        check the list to see if the frequency was already there.
        """
        self._parse_changes()

        for traversed_frequency in self._traverse_frequencies():
            if traversed_frequency in self.traversed_frequencies:
                first_frequency_reached_twice = traversed_frequency
                return first_frequency_reached_twice
            self.traversed_frequencies.add(traversed_frequency)

        raise ValueError(f"Shouldn't happen | Traversed frequencies: {self.traversed_frequencies}")

    def _parse_changes(self):
        def all_changes():
            for line in self._input.splitlines():
                yield self._parse_line(line)

        self.changes = list(all_changes())

    def _traverse_frequencies(self):
        freq = self.initial_freq
        for change in itertools.cycle(self.changes):
            freq += change
            yield freq

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
