from textwrap import dedent

import pytest

from days.day_3 import Day3

EXAMPLE_INPUT = dedent(
        """
        00100
        11110
        10110
        10111
        10101
        01111
        00111
        11100
        10000
        11001
        00010
        01010
        """
)


@pytest.fixture
def day():
    return Day3(EXAMPLE_INPUT)


def test_example_part_1(day):
    assert day.solve_part_1() == "198"


def test_example_part_2(day):
    assert day.solve_part_2() == "asdf"