import pytest

from days.day_1 import Day1


def test_example_part_1():
    day1 = Day1(
        """1000
2000
3000

4000

5000
6000

7000
8000
9000

10000"""
    )
    assert day1.solve_part_1() == "24000"


@pytest.mark.skip("not implemented")
def test_example_part_2():
    day1 = Day1("""""")
    assert day1.solve_part_2() == ""
