import re
from collections import deque
from dataclasses import dataclass
from math import inf

import matplotlib.pyplot as plt
import pandas as pd
import seaborn as sns

from days.day import Day
from tests import test_day16
from tools.visualizer import GraphvizVisualizer


@dataclass(frozen=True)
class Room:
    id: str
    flow: int
    links_to: (str,)

    def __str__(self):
        return f"{self.id} ({self.flow})"


LINE_REGEX = r"^Valve (?P<valve>[A-Z]{2}) has flow rate=(?P<flow>\d+); tunnels? leads? to valves? (?P<links>.+)$"


def parse_room(line):
    result = re.search(LINE_REGEX, line)
    return Room(
        id=result.group("valve"),
        flow=int(result.group("flow")),
        links_to=tuple(result.group("links").split(", ")),
    )


REMAINING_TOTAL = 30

START_ROOM_ID = "AA"


class Day16(Day):
    def solve_part_1(self):
        def plot_dp():
            df = pd.DataFrame(dp)
            sns.heatmap(df, annot=True, vmin=0)
            plt.show()

        rooms = self.input_lines(parse_room)
        room_map: dict[Room] = {r.id: r for r in rooms}
        dp = {r.id: [-inf] * (REMAINING_TOTAL + 1) for r in rooms}
        opened = {r.id: [False] * (REMAINING_TOTAL + 1) for r in rooms}

        next_queue = deque()
        next_queue.append(START_ROOM_ID)
        dp[START_ROOM_ID][0] = 0
        elapsed = 1
        breaker = 0
        break_at = 20

        while elapsed <= 30 and breaker < break_at:
            plot_dp()
            print("elapsed =", elapsed)
            remaining = REMAINING_TOTAL - elapsed
            queue = next_queue
            next_queue = deque()

            while queue and breaker < break_at:
                breaker += 1
                curr: Room = room_map[queue.pop()]
                print(curr)
                visited[curr.id][elapsed] = True

                max_if_moving = max(
                    (dp[linked][elapsed - 1] for linked in curr.links_to),
                    default=0,
                )
                max_if_opening = (
                    dp[curr.id][elapsed - 1] + curr.flow * remaining
                )
                dp[curr.id][elapsed] = max(max_if_moving, max_if_opening)
                for linked in curr.links_to:
                    if not visited[linked][elapsed]:
                        next_queue.append(linked)

            elapsed += 1

        # show_rooms(room_map)

    def solve_part_2(self):
        raise RuntimeError("Not yet implemented!")


class GraphvizRoomsVisualizer(GraphvizVisualizer):
    def build_graph(self, room_map: dict[Room]):
        for room in room_map.values():
            self.graph.node(str(room))

        added = set()
        for room in room_map.values():
            for l in room.links_to:
                linked_room: Room = room_map[l]
                if (linked_room, room) not in added:
                    added.add((room, linked_room))
                    self.graph.edge(str(room), str(linked_room))

    def show(self):
        self.graph.view()


def show_rooms(room_map):
    visualizer = GraphvizRoomsVisualizer()
    visualizer.build_graph(room_map)
    visualizer.show()


if __name__ == "__main__":
    Day16(test_day16.EXAMPLE_INPUT).solve_part_1()
