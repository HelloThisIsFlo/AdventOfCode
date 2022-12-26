import os
from importlib import import_module

import requests
from dotenv import load_dotenv

from days.day import Day

YEAR = 2022
DAYS_TO_RUN = [
    1,
]


def get_session_value():
    key = "COOKIE_SESSION_VALUE"
    if key not in os.environ:
        raise RuntimeError(
            "Make sure to create a '.env' file at the root of "
            f"this project with: '{key}=XXXXXX'. "
            "Where XXXXXX is the value of the session cookie"
            "in Advent Of Code (after login)"
        )
    return os.environ[key]


def solve_and_print_result(day_number):
    def load_day_class():
        day_module = import_module(f"days.day_{day_number}")
        return getattr(day_module, f"Day{day_number}")

    def download_puzzle_input():
        return requests.get(
            f"https://adventofcode.com/{YEAR}/day/{day_number}/input",
            cookies={"session": get_session_value()},
        ).text

    day_class = load_day_class()
    puzzle_input = download_puzzle_input()
    day: Day = day_class(puzzle_input)

    print("")
    print(f"{day_class.__name__}.1: {day.solve_part_1()}")
    print(f"{day_class.__name__}.2: {day.solve_part_2()}")


def print_intro():
    print("")
    print(f"Solutions to Advent of Code {YEAR}")
    print("--------------------------------")


if __name__ == "__main__":
    load_dotenv()
    print_intro()
    for day_number in DAYS_TO_RUN:
        solve_and_print_result(day_number)
