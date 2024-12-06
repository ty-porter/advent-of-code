from src.prompt import Prompt
from src.utils import Direction2D, Position2D

from itertools import cycle, islice

GUARD = "^"
OBSTACLE = "#"
DIRECTIONS = [
    Direction2D(0, -1),  # up
    Direction2D(1, 0),  # right
    Direction2D(0, 1),  # down
    Direction2D(-1, 0),  # left
]


def generate_path(start, grid, hash_fn, obstacle=None, start_direction=None):
    guard = Position2D(start.x, start.y)

    if start_direction is not None:
        d = start_direction
        start_idx = DIRECTIONS.index(start_direction)
        direction = islice(cycle(DIRECTIONS), start_idx, start_idx + len(DIRECTIONS))
    else:
        direction = cycle(DIRECTIONS)

    d = next(direction)
    path = {}

    while (
        guard.y > 0
        and guard.y < len(grid) - 1
        and guard.x > 0
        and guard.x < len(grid) - 1
    ):
        if hash_fn(guard, d) in path:
            if obstacle is not None:
                return (path, True)

            path[hash_fn(guard, d)].append(d)
        else:
            path[hash_fn(guard, d)] = [d]

        if (
            obstacle is not None
            and guard.x + d.x == obstacle.x
            and guard.y + d.y == obstacle.y
        ):
            d = next(direction)
        elif grid[guard.y + d.y][guard.x + d.x] == OBSTACLE:
            d = next(direction)
        else:
            guard += d

    if hash_fn(guard, d) in path:
        path[hash_fn(guard, d)].append(d)
    else:
        path[hash_fn(guard, d)] = [d]

    return (path, False)


def part_1_solution(args):
    guard, grid = args

    hash_guard = lambda g, _: g
    path, _ = generate_path(guard, grid, hash_guard)

    return len(list(path.keys()))


def part_2_solution(args):
    guard, grid = args

    hash_guard_dir = lambda g, d: (g, d)
    path, _ = generate_path(guard, grid, hash_guard_dir)

    total = 0

    for node in path:
        guard2, direction = node
        obstacle = Position2D(guard2.x + direction.x, guard2.y + direction.y)
        _, is_cycle = generate_path(guard2, grid, hash_guard_dir, obstacle, direction)

        if is_cycle:
            total += 1

    return total


def transform_prompt():
    grid = Prompt.read_to_grid(__file__, test=True)

    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == GUARD:
                return Position2D(x, y), grid
