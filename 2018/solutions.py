import itertools
import re
from abc import ABCMeta, abstractmethod
from pathlib import Path


class Day(metaclass=ABCMeta):
    def __init__(self, input_as_string: str):
        self._input: str = input_as_string

    @classmethod
    def from_problem_input_file(cls):
        def get_problem_input_file_name() -> str:
            class_name = cls.__name__
            problem_input_file_name = f'{class_name.lower()}.txt'
            return problem_input_file_name

        def read_file(file_name) -> str:
            file_path = Path('./inputs') / file_name
            with file_path.open('r') as file:
                return file.read()

        input_file_name = get_problem_input_file_name()
        input_as_string = read_file(input_file_name)
        return cls(input_as_string)

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


class Day2(Day):
    """
    --- Part One ---
    To make sure you didn't miss any, you scan the likely candidate boxes again, counting the number
    that have an ID containing exactly two of any letter and then separately counting those with
    exactly three of any letter. You can multiply those two counts together to get a rudimentary
    checksum and compare it to what your device predicts.

    For example, if you see the following box IDs:

    'abcdef' contains no letters that appear exactly two or three times.
    'bababc' contains two a and three b, so it counts for both.
    'abbcde' contains two b, but no letter appears exactly three times.
    'abcccd' contains three c, but no letter appears exactly two times.
    'aabcdd' contains two a and two d, but it only counts once.
    'abcdee' contains two e.
    'ababab' contains three a and three b, but it only counts once.

    Of these box IDs, four of them contain a letter which appears exactly twice, and three of
    them contain a letter which appears exactly three times. Multiplying these together produces
    a checksum of 4 * 3 = 12.

    What is the checksum for your list of box IDs?


    --- Part Two ---
    """

    def __init__(self, input_as_string: str):
        super().__init__(input_as_string)
        self.box_names = self._parse_box_names()
        self.number_of_boxes_with_duplicates = 0
        self.number_of_boxes_with_triplicates = 0

    def solve_part_1(self):
        """
        Checksum:
        - Find number of boxes with duplicate letters
        - Find number of boxes with triplicate letters
        - Multiply these numbers
        """

        self._count_box_names_with_duplicates_and_triplicates()
        checksum = self.number_of_boxes_with_duplicates * self.number_of_boxes_with_triplicates
        return checksum

    def solve_part_2(self):
        pass

    def _parse_box_names(self):
        return self._input.splitlines()

    def _count_box_names_with_duplicates_and_triplicates(self):
        for name in self.box_names:
            if self._contains_exactly(2).occurrences_of_any_letters(name):
                self.number_of_boxes_with_duplicates += 1
            if self._contains_exactly(3).occurrences_of_any_letters(name):
                self.number_of_boxes_with_triplicates += 1

    @staticmethod
    def _contains_exactly(number_of_occurrences):
        class Wrapper:
            @staticmethod
            def occurrences_of_any_letters(name):
                from collections import Counter
                count_of_appearance_for_each_letter = Counter(name)
                if number_of_occurrences in count_of_appearance_for_each_letter.values():
                    return True
                else:
                    return False

        return Wrapper()
