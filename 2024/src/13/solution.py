from src.prompt import Prompt
from src.utils import Vec2, Position2D

from dataclasses import dataclass, field
from queue import PriorityQueue

import re


class Button(Vec2):
    def __init__(self, cost, x, y):
        super().__init__(x, y)

        self.cost = cost


@dataclass(order=True)
class PQueueEntry:
    distance: int
    cost: int
    position: Position2D = field(compare=False)
    a_pressed: int = field(compare=False)
    b_pressed: int = field(compare=False)


def dfs(a, b, prize):
    pq = PriorityQueue()
    origin = Position2D()

    if origin == prize:
        return 0

    visited = {}

    entry = PQueueEntry(origin.manhattan_distance(prize), 0, origin, 0, 0)

    pq.put(entry)

    while not pq.empty():
        entry = pq.get()

        if entry.position == prize:
            return entry.cost

        if entry.position in visited:
            continue

        visited[entry.position] = 1

        if entry.a_pressed < 100:
            pressed = entry.position + a

            pq.put(
                PQueueEntry(
                    pressed.manhattan_distance(prize),
                    entry.cost + a.cost,
                    pressed,
                    entry.a_pressed + 1,
                    entry.b_pressed,
                )
            )

        if entry.b_pressed < 100:
            pressed = entry.position + b

            pq.put(
                PQueueEntry(
                    pressed.manhattan_distance(prize),
                    entry.cost + b.cost,
                    pressed,
                    entry.a_pressed,
                    entry.b_pressed + 1,
                )
            )

    return 0


def part_1_solution(machines):
    total = 0

    for machine in machines:
        a, b, prize = machine

        total += dfs(a, b, prize)

    return total


def part_2_solution(values):
    return


def transform_prompt():
    parsed_machines = []

    machines = Prompt.read_to_list(__file__)
    for m in range(0, len(machines) + 1, 4):
        a, b, p = machines[m : m + 3]

        parse_nums = lambda s: list(int(d) for d in re.findall("\d+", s))

        button_a = Button(3, *parse_nums(a))
        button_b = Button(1, *parse_nums(b))
        prize = Position2D(*parse_nums(p))
        parsed_machines.append((button_a, button_b, prize))

    return parsed_machines
