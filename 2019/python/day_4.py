from base import Day
from math import floor
from utils import digitize


class Grouper:
    def __init__(self, list_):
        self.list = list_
        self.current_group = None
        self.grouped = []

    def start_new_group_with_item(self, item):
        if self.current_group:
            self.grouped.append(self.current_group)
        self.current_group = [item]

    def group(self):
        self.start_new_group_with_item(self.list[0])
        for item in self.list[1::]:
            if item in self.current_group:
                self.current_group.append(item)
            else:
                self.start_new_group_with_item(item)

        # Append last group
        self.grouped.append(self.current_group)
        return self.grouped


def group(list_):
    """
    Groups by similar adjacent items.

    >>> list_ = [1, 1, 2, 3, 4, 5, 5, 6]
    >>> grouped_list = group(list_)
    >>> grouped_list
    [[1, 1], [2], [3], [4], [5, 5], [6]]
    """
    return Grouper(list_).group()


def is_valid_pass(password, range_, strict_adjacent_rule=False):
    digits = digitize(password)

    def is_6_digits():
        return len(digits) >= 6

    def is_in_range():
        return password in range_

    def has_2_similar_adjacent_digits():
        grouped_digits = group(digits)

        if strict_adjacent_rule:
            def condition(digit_group):
                return len(digit_group) == 2
        else:
            def condition(digit_group):
                return len(digit_group) >= 2

        return any(condition(group) for group in grouped_digits)

    def digits_never_decrease():
        previous = digits[0]
        for digit in digits[1::]:
            if digit < previous:
                return False
            previous = digit

        return True

    return (
        is_6_digits() and
        is_in_range() and
        has_2_similar_adjacent_digits() and
        digits_never_decrease()
    )


class Day4(Day):
    def find_number_of_valid_passwords_from_input_range(self, strict_adjacent_rule=False):
        [start, end] = [int(val) for val in self.input_lines()[0].split('-')]
        num_of_valid_passwords = 0

        password_range = range(start, end + 1)
        for candidate in password_range:
            if is_valid_pass(candidate, password_range, strict_adjacent_rule=strict_adjacent_rule):
                num_of_valid_passwords += 1

        return num_of_valid_passwords

    def solve_part_1(self):
        return str(
            self.find_number_of_valid_passwords_from_input_range()
        )

    def solve_part_2(self):
        return str(
            self.find_number_of_valid_passwords_from_input_range(
                strict_adjacent_rule=True)
        )
