from textwrap import dedent
import pytest


from day_1 import Day1, full_required_all_inclusive
from day_2 import Day2


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
    class TestPart1:
        def test_single_operation(self):
            assert_solution_part_1(
                Day2,
                given_input="""\
                1,0,0,0,99
                """,
                expected_solution='2,0,0,0,99'
            )
            assert_solution_part_1(
                Day2,
                given_input="""\
                2,3,0,3,99
                """,
                expected_solution='2,3,0,6,99'
            )
            assert_solution_part_1(
                Day2,
                given_input="""\
                2,4,4,5,99,0
                """,
                expected_solution='2,4,4,5,99,9801'
            )

        def test_multiple_operation(self):
            assert_solution_part_1(
                Day2,
                given_input="""\
                1,1,1,4,99,5,6,0,99
                """,
                expected_solution='30,1,1,4,2,5,6,0,99'
            )
