from unittest.mock import patch

from base import Day
from day_1 import Day1
from day_2 import Day2
from day_3 import Day3
from day_4 import Day4
from day_5 import Day5
from day_6 import Day6


@patch('computer.io.prompt_user_for_input')
@patch('computer.io.display_output_to_user')
def solve_and_print_result(
    day_class,
    mock_display_output_to_user,
    mock_prompt_user_for_input,
    step_1_user_input=None,
    step_2_user_input=None
):
    def last_outputted_value():
        ((last_outputted_value,), _) = mock_display_output_to_user.call_args
        return last_outputted_value

    day: Day = day_class.from_problem_input_file()

    if step_1_user_input:
        mock_prompt_user_for_input.side_effect = step_1_user_input
        day.solve_part_1()
        part1_result = last_outputted_value()
    else:
        part1_result = day.solve_part_1()

    if step_2_user_input:
        mock_prompt_user_for_input.side_effect = step_2_user_input
        day.solve_part_2()
        part2_result = last_outputted_value()
    else:
        part2_result = day.solve_part_2()

    print('')
    print(f'{day_class.__name__}.1: {part1_result}')
    print(f'{day_class.__name__}.2: {part2_result}')


def test_print_intro():
    print('')
    print('Solutions to Advent of Code 2018')
    print('--------------------------------')


def test_solve_day_1():
    solve_and_print_result(Day1)


def test_solve_day_2():
    solve_and_print_result(Day2)


def test_solve_day_3():
    solve_and_print_result(Day3)


def test_solve_day_4():
    solve_and_print_result(Day4)


def test_solve_day_5():
    solve_and_print_result(
        Day5,
        step_1_user_input=[1],
        step_2_user_input=[5],
    )


def test_solve_day_6():
    solve_and_print_result(Day6)
