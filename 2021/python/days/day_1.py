from math import floor, inf

from days.day import Day


class Day1(Day):
    def solve_part_1(self):
        return str(self.count_of_increases(self.input_lines(int)))

    def solve_part_2(self):
        input_lines = self.input_lines(int)
        sliding_windows = [input_lines[i-1] + input_lines[i] + input_lines[i+1]
                          for i in range(1, len(input_lines) - 1)]
        return str(self.count_of_increases(sliding_windows))

    @staticmethod
    def count_of_increases(items):
        previous = inf
        count = 0
        for i in items:
            if i > previous:
                count += 1
            previous = i
        return str(count)
