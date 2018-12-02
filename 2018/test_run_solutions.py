from solutions import Day1, Day, Day2


def solve_and_print_result(day_class):
    day: Day = day_class.from_problem_input_file()
    part1 = day.solve_part_1()
    part2 = day.solve_part_2()
    print('')
    print(f'{day_class.__name__}.1: {part1}')
    print(f'{day_class.__name__}.2: {part2}')


def test_solve_day_1():
    solve_and_print_result(Day1)


def test_solve_day_2():
    solve_and_print_result(Day2)
