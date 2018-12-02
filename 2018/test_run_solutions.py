from solutions import Day1, Day


def solve_and_print_result(day_class):
    day: Day = day_class.from_problem_input_file()
    part1 = day.solve_part_1()
    part2 = day.solve_part_2()
    print('')
    print(f'{day_class.__name__}.1: {part1}')
    print(f'{day_class.__name__}.2: {part2}')


# @pytest.mark.skip
def test_solve_day_1():
    solve_and_print_result(Day1)
