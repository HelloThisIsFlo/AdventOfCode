from days.day_2 import Day2


def test_example_part_1():
    day = Day2("""forward 5
down 5
forward 8
up 3
down 8
forward 2    
""")
    assert day.solve_part_1() == "150"


def test_example_part_2():
    day = Day2("""forward 5
down 5
forward 8
up 3
down 8
forward 2    
""")
    assert day.solve_part_2() == "900"
