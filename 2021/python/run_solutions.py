from days.day import Day
from days.day_1 import Day1


def solve_and_print_result(day_class):
    day: Day = day_class.from_problem_input_file()

    part1_result = day.solve_part_1()
    part2_result = day.solve_part_2()

    print('')
    print(f'{day_class.__name__}.1: {part1_result}')
    print(f'{day_class.__name__}.2: {part2_result}')


def print_intro():
    print('')
    print('Solutions to Advent of Code 2021')
    print('--------------------------------')


if __name__ == '__main__':
    print_intro()
    for day_class in [
        Day1
    ]:
        solve_and_print_result(day_class)
