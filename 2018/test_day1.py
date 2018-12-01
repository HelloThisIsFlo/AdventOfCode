from textwrap import dedent

from day1 import Day1


def assert_input_gives_output(given_input, expected_output):
    day1 = Day1(dedent(given_input))
    assert day1.solve() == expected_output


def test_single_number():
    assert_input_gives_output(
        given_input="""\
        +1
        """,
        expected_output=1)


def test_multiple_numbers():
    assert_input_gives_output(
        given_input="""\
        +1
        +1
        -44
        +127
        """,
        expected_output=85)
