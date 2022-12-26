from days.day_16 import Day16
from pytest import mark

from tests.common import highlight

EXAMPLE_INPUT = """Valve AA has flow rate=0; tunnels lead to valves DD, II, BB
Valve BB has flow rate=13; tunnels lead to valves CC, AA
Valve CC has flow rate=2; tunnels lead to valves DD, BB
Valve DD has flow rate=20; tunnels lead to valves CC, AA, EE
Valve EE has flow rate=3; tunnels lead to valves FF, DD
Valve FF has flow rate=0; tunnels lead to valves EE, GG
Valve GG has flow rate=0; tunnels lead to valves FF, HH
Valve HH has flow rate=22; tunnel leads to valve GG
Valve II has flow rate=0; tunnels lead to valves AA, JJ
Valve JJ has flow rate=21; tunnel leads to valve II"""


@highlight
def test_example_part_1():
    day1 = Day16(EXAMPLE_INPUT)
    assert day1.solve_part_1() == "1651"


@mark.skip("not solved yet")
def test_example_part_2():
    day1 = Day16(EXAMPLE_INPUT)
    assert day1.solve_part_2() == "45000"
