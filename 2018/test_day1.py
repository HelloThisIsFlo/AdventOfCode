from textwrap import dedent

from day1 import Day1


def assert_solution_part_1(given_input, expected_solution):
    day1 = Day1(dedent(given_input))
    assert day1.solve_part_1() == expected_solution


def assert_solution_part_2(given_input, expected_solution):
    day1 = Day1(dedent(given_input))
    assert day1.solve_part_2() == expected_solution


class TestDay1:
    class TestPart1:
        def test_single_number(self):
            assert_solution_part_1(
                given_input="""\
                +1
                """,
                expected_solution=1)

        def test_multiple_numbers(self):
            assert_solution_part_1(
                given_input="""\
                +1
                +1
                -44
                +127
                """,
                expected_solution=85)

    class TestPart2:
        def test_basic_example(self):
            assert_solution_part_2(
                given_input="""\
                +1
                -1
                """,
                expected_solution=0)

            assert_solution_part_2(
                given_input="""\
                +3
                +3
                +4
                -2
                -4
                """,
                expected_solution=10)

            assert_solution_part_2(
                given_input="""\
                -6
                +3
                +8
                +5
                -6
                """,
                expected_solution=5)

            assert_solution_part_2(
                given_input="""\
                +7
                +7
                -2
                -7
                -4
                """,
                expected_solution=14)
