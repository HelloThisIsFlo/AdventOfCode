from textwrap import dedent
import pytest
from unittest import mock
from unittest.mock import patch


from day_1 import Day1, full_required_all_inclusive
from day_2 import Day2, Program


def assert_solution_part_1(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_1() == expected_solution


def assert_solution_part_2(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_2() == expected_solution


class TestDay1:
    class TestPart1:
        def test_single_module(self):
            assert_solution_part_1(
                Day1,
                given_input="""\
                12
                """,
                expected_solution='2'
            )
            assert_solution_part_1(
                Day1,
                given_input="""\
                1969
                """,
                expected_solution='654'
            )

        def test_multiple_module(self):
            assert_solution_part_1(
                Day1,
                given_input="""\
                12
                1969
                """,
                expected_solution='656'
            )

    class TestFuelAllInclusive:
        def test_from_example(self):
            assert full_required_all_inclusive(14) == 2
            assert full_required_all_inclusive(1969) == 966


class TestDay2:
    class TestProgram:
        def test_single_instruction_add(self):
            assert Program([1, 0, 0, 0, 99]).run() == [2, 0, 0, 0, 99]

        def test_single_instruction_multiply(self):
            assert Program([2, 3, 0, 3, 99]).run() == [2, 3, 0, 6, 99]
            assert Program([2, 4, 4, 5, 99, 0]).run() == [2, 4, 4, 5, 99, 9801]

        def test_multiple_instructions(self):
            assert Program(
                [1, 1, 1, 4, 99, 5, 6, 0, 99]
            ).run() == [30, 1, 1, 4, 2, 5, 6, 0, 99]

    class TestPart1:
        def test_it_replaces_values_at_addresses_1_and_2(self):
            day_2 = Day2("1,0,0,0,99")
            assert day_2.parse_input() == [1, 12, 2, 0, 99]

        @patch.object(Day2, 'parse_input')
        @patch('day_2.Program')
        def test_it_runs_program_with_parsed_input(self, MockProgram, mock_parse_input):
            program = MockProgram.return_value
            program.run.return_value = [1, 0, 0, 0, 99]

            Day2("MOCK_INPUT").solve_part_1()

            MockProgram.assert_called_once_with(mock_parse_input.return_value)
            program.run.assert_called_once()

        @patch.object(Day2, 'parse_input')
        @patch('day_2.Program')
        def test_it_returns_formatted_result(self, MockProgram, mock_parse_input):
            program = MockProgram.return_value
            program.run.return_value = [12345, 0, 0, 0, 99]
            expected_result = '12345'

            result = Day2("MOCK_INPUT").solve_part_1()

            assert result == expected_result
