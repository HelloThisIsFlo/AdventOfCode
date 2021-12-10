from textwrap import dedent

import pytest

from days.day_4 import Day4, Board
from tests.common import highlight

EXAMPLE_INPUT = dedent(
        """
        7,4,9,5,11,17,23,2,0,14,21,24,10,16,13,6,15,25,12,22,18,20,8,19,3,26,1

        22 13 17 11  0
         8  2 23  4 24
        21  9 14 16  7
         6 10  3 18  5
         1 12 20 15 19
        
         3 15  0  2 22
         9 18 13 17  5
        19  8  7 25 23
        20 11 10 24  4
        14 21 16 12  6
        
        14 21 17 24  4
        10 16 15  9 19
        18  8 23 26 20
        22 11 13  6  5
         2  0 12  3  7
        """
)


@pytest.fixture
def day():
    return Day4(EXAMPLE_INPUT)


def test_example_part_1(day):
    assert day.solve_part_1() == "4512"


def test_example_part_2(day):
    # "25344" was too high
    assert day.solve_part_2() == "1924"


def test_board_complete_row():
    board = Board([
        [11, 12, 13, 14, 15],
        [21, 22, 23, 24, 25],
        [31, 32, 33, 34, 35],
        [41, 42, 43, 44, 45],
        [51, 52, 53, 54, 55],
    ])

    board.try_num(21)
    board.try_num(22)
    board.try_num(23)
    board.try_num(24)
    assert not board.is_complete()
    board.try_num(25)
    assert board.is_complete()


def test_board_complete_col():
    board = Board([
        [11, 12, 13, 14, 15],
        [21, 22, 23, 24, 25],
        [31, 32, 33, 34, 35],
        [41, 42, 43, 44, 45],
        [51, 52, 53, 54, 55],
    ])

    board.try_num(12)
    board.try_num(22)
    board.try_num(32)
    board.try_num(42)
    assert not board.is_complete()
    board.try_num(52)
    assert board.is_complete()


def test_sandbox():
    sandbox = 'yo ' * 5
    print(f'{sandbox=}')