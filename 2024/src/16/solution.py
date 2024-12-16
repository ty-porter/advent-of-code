from src.prompt import Prompt
from src.utils import Position2D, Direction2D, CARDINAL_2D, skippable

from dataclasses import dataclass, field
from queue import PriorityQueue
from typing import List

OBSTACLE = "#"
START = "S"
FINISH = "E"

TURN_COST = 1000
MOVE_COST = 1


@dataclass(order=True)
class SearchEntry:
    cost: int
    position: Position2D = field(compare=False)
    previous_direction: Direction2D = field(compare=False)
    path: List[Position2D] = field(compare=False)


def part_1_solution(args):
    start, finish, obstacles = args
    pq = PriorityQueue()
    pq.put(SearchEntry(0, start, Direction2D.RIGHT(), []))

    visited = {}

    while not pq.empty():
        entry = pq.get()

        if entry.position == finish:
            return entry.cost

        if entry.position in visited and entry.cost > visited[entry.position]:
            continue

        visited[entry.position] = entry.cost

        for direction in CARDINAL_2D:
            if entry.position + direction in entry.path:
                continue

            if entry.position + direction in obstacles:
                continue

            new_cost = entry.cost + MOVE_COST

            if direction != entry.previous_direction:
                new_cost += TURN_COST

            pq.put(
                SearchEntry(
                    new_cost,
                    entry.position + direction,
                    direction,
                    [*entry.path, entry.position + direction],
                )
            )

    return -1


@skippable("16p2")
def part_2_solution(args):
    start, finish, obstacles = args
    pq = PriorityQueue()
    pq.put(SearchEntry(0, start, Direction2D.RIGHT(), []))

    visited = {}
    paths = {start: 0}
    best_cost = 1e100

    while not pq.empty():
        entry = pq.get()

        if entry.position == finish:
            if entry.cost > best_cost:
                continue
            elif entry.cost < best_cost:
                best_cost = entry.cost
                paths = {start: 0}

            for position in entry.path:
                paths[position] = 1

        visit_key = (entry.position, entry.previous_direction)
        if visit_key in visited and entry.cost > visited[visit_key]:
            continue

        visited[visit_key] = entry.cost

        for direction in CARDINAL_2D:
            if entry.position + direction in entry.path:
                continue

            if entry.position + direction in obstacles:
                continue

            new_cost = entry.cost + MOVE_COST

            if direction != entry.previous_direction:
                new_cost += TURN_COST

            if new_cost > best_cost:
                continue

            pq.put(
                SearchEntry(
                    new_cost,
                    entry.position + direction,
                    direction,
                    [*entry.path, entry.position + direction],
                )
            )

    return len(paths)


def transform_prompt():
    lines = Prompt.read_to_list(__file__)
    obstacles = {}
    start = finish = None

    for y, row in enumerate(lines):
        for x, col in enumerate(row):
            if col == OBSTACLE:
                obstacles[Position2D(x, y)] = OBSTACLE

            elif col == START:
                start = Position2D(x, y)
            elif col == FINISH:
                finish = Position2D(x, y)

    return start, finish, obstacles
