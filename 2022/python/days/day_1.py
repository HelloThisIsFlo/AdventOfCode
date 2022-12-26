from heapq import heappush, heappop

from collections import deque
from pytest_watch.helpers import dequeue_all

from days.day import Day


def parse_to_number_or_next_elf(line):
    return int(line) if line else "NEXT_ELF"


class ElfCaloriesMaxHeap:
    def __init__(self):
        self.min_heap = []

    def save_elf_total(self, total):
        heappush(self.min_heap, -total)

    def pop_max_calories(self):
        return -heappop(self.min_heap)


class Day1(Day):
    def __init__(self, input_as_string: str):
        super().__init__(input_as_string)
        self.calories = None

    def solve_part_1(self):
        self.compute_and_sort_elf_calories()
        return str(self.calories.pop_max_calories())

    def compute_and_sort_elf_calories(self):
        self.calories = ElfCaloriesMaxHeap()
        lines = self.input_lines(parse_to_number_or_next_elf, allow_empty=True)
        curr_total = 0
        for l in lines:
            match l:
                case "NEXT_ELF":
                    self.calories.save_elf_total(curr_total)
                    curr_total = 0
                case _:
                    curr_total += l
        self.calories.save_elf_total(curr_total)

    def solve_part_2(self):
        self.compute_and_sort_elf_calories()
        return str(
            self.calories.pop_max_calories()
            + self.calories.pop_max_calories()
            + self.calories.pop_max_calories()
        )
