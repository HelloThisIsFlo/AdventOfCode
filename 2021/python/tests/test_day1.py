from days.day_1 import Day1


def test_example_part_1():
    day1 = Day1("""199
200
208
210
200
207
240
269
260
263
""")
    assert day1.solve_part_1() == "7"


def test_example_part_2():
    day1 = Day1("""199
200
208
210
200
207
240
269
260
263
""")
    assert day1.solve_part_2() == "5"
