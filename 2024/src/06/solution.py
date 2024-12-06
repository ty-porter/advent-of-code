from src.prompt import Prompt
from src.utils import Coord

import itertools

Dir = Pos = Coord

GUARD = '^'
OBSTACLE = '#'
DIRECTIONS = [
    Dir(0, -1), # up
    Dir(1, 0),  # right
    Dir(0, 1),  # down
    Dir(-1, 0)  # left
]

def generate_path(start, grid, hash_fn, obstacle=None):
    guard = Pos(start.x, start.y)

    direction = itertools.cycle(DIRECTIONS)
    d = next(direction)
    path = {}

    while guard.y > 0 and guard.y < len(grid) - 1 and guard.x > 0 and guard.x < len(grid) - 1:
        if hash_fn(guard, d) in path:
            if obstacle is not None:
                return (path, True)

            path[hash_fn(guard, d)].append(d)
        else:
            path[hash_fn(guard, d)] = [d]

        if obstacle is not None and guard.x + d.x == obstacle.x and guard.y + d.y == obstacle.y:
            d = next(direction)
        elif grid[guard.y + d.y][guard.x + d.x] == OBSTACLE:
            d = next(direction)
        else:
            guard.x += d.x
            guard.y += d.y

    if hash_fn(guard, d) in path:
        path[hash_fn(guard, d)].append(d)
    else:
        path[hash_fn(guard, d)] = [d]

    return (path, False)

def part_1_solution(args):
    guard, grid = args

    hash_guard = lambda guard, _: (guard.x, guard.y)
    path, _ = generate_path(guard, grid, hash_guard)

    return len(list(path.keys()))


def part_2_solution(args):
    guard, grid = args

    hash_guard_dir = lambda guard, direction: (guard.x, guard.y, direction.x, direction.y)
    path, _ = generate_path(guard, grid, hash_guard_dir)

    total = 0

    for node in path:
        guard2 = Pos(node[0], node[1])
        obstacle = Pos(node[0] + node[2], node[1]+ node[3])
        _, is_cycle = generate_path(guard2, grid, hash_guard_dir, obstacle)

        if is_cycle:
            print(obstacle, guard2, (node[2], node[3]))
            total += 1

    return total

def transform_prompt():
    grid = Prompt.read_to_grid(__file__, test=True)
    
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == GUARD:
                return Pos(x, y), grid
