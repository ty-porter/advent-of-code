from src.prompt import Prompt
from src.utils import Coord

XMAS = "XMAS"
X_MAS = "AMS"  # Sorted MAS

Dir = Pos = Coord


def find_target(target, grid, x, y):
    dirs = [
        Dir(0, 1),  #  N
        Dir(0, -1),  #  S
        Dir(-1, 0),  #  W
        Dir(1, 0),  #  E
        Dir(1, 1),  # NE
        Dir(1, -1),  # SE
        Dir(-1, -1),  # SW
        Dir(-1, 1),  # NW
    ]

    total = 0

    for d in dirs:
        pos = Pos(x, y)
        search = ""

        for _ in range(len(target)):
            search += grid[pos.y][pos.x]

            if search != target[0 : len(search)]:
                break

            nx = d.x + pos.x
            ny = d.y + pos.y

            if ny < 0 or ny >= len(grid):
                break

            if nx < 0 or nx >= len(grid[ny]):
                break

            pos.x = nx
            pos.y = ny

        total += search == target

    return total


def find_x_target(target, grid, x, y):
    if y < 1 or y > len(grid) - 2:
        return 0

    if x < 1 or x > len(grid[y]) - 2:
        return 0

    x_mas_sw_to_ne = "".join(
        sorted(grid[y + 1][x - 1] + grid[y][x] + grid[y - 1][x + 1])
    )

    x_mas_nw_to_se = "".join(
        sorted(grid[y - 1][x - 1] + grid[y][x] + grid[y + 1][x + 1])
    )

    return target == x_mas_nw_to_se and target == x_mas_sw_to_ne


def part_1_solution(grid):
    total = 0

    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            if char != XMAS[0]:
                continue

            total += find_target(XMAS, grid, x, y)

    return total


def part_2_solution(grid):
    total = 0

    for y, row in enumerate(grid):
        for x, char in enumerate(row):
            if char != X_MAS[0]:
                continue

            total += find_x_target(X_MAS, grid, x, y)

    return total


def transform_prompt():
    return Prompt.read_to_list(__file__)
