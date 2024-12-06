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

def generate_path(start, grid):
    guard = Pos(start.x, start.y)

    direction = itertools.cycle(DIRECTIONS)
    d = next(direction)
    path = {}

    while guard.y > 0 and guard.y < len(grid) - 1 and guard.x > 0 and guard.x < len(grid) - 1:
        path[(guard.x, guard.y)] = 1

        if grid[guard.y + d.y][guard.x + d.x] == OBSTACLE:
            d = next(direction)
        else:
            guard.x += d.x
            guard.y += d.y

    path[(guard.x, guard.y)] = 1

    return path

def part_1_solution(args):
    guard, grid = args

    path = generate_path(guard, grid)

    return len(list(path.keys()))


def part_2_solution(args):
    guard_start, grid = args

    total = 0

    for obs_y in range(len(grid)):
        for obs_x in range(len(grid[obs_y])):
            guard = Pos(guard_start.x, guard_start.y)
            direction = itertools.cycle(DIRECTIONS)
            d = next(direction)
            visited = {}
            cycle = False

            while guard.y > 0 and guard.y < len(grid) - 1 and guard.x > 0 and guard.x < len(grid) - 1:
                if (guard.x, guard.y, d.x, d.y) in visited:
                    cycle = True
                    break

                visited[(guard.x, guard.y, d.x, d.y)] = 1

                if guard.y + d.y == obs_y and guard.x + d.x == obs_x:
                    d = next(direction)
                elif grid[guard.y + d.y][guard.x + d.x] == OBSTACLE:
                    d = next(direction)
                else:
                    guard.x += d.x
                    guard.y += d.y

            if cycle:
                total += 1

    return total

def transform_prompt():
    grid = Prompt.read_to_grid(__file__, test=False)
    
    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c == GUARD:
                return Pos(x, y), grid
