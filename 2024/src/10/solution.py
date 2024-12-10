from src.prompt import Prompt
from src.utils import Position2D, CARDINAL_2D

from collections import deque


def grid_at(grid, x, y):
    if y < 0 or y >= len(grid):
        return None
    
    if x < 0 or x >= len(grid[0]):
        return None
    
    return grid[y][x]
    
def bfs(grid, position):
    queue = deque([position])

    nines = {}
    paths = 0

    while queue:
        p1 = queue.popleft()
        v1 = grid_at(grid, p1.x, p1.y)

        if v1 == 9:
            nines[p1] = 1
            paths += 1
            continue
        elif v1 == None:
            continue

        for d in CARDINAL_2D:
            p2 = p1 + d

            v2 = grid_at(grid, p2.x, p2.y)
            
            if v2 == v1 + 1:
                queue.append(p2)

    return nines, paths

def part_1_solution(args):
    grid, trailheads = args

    return sum(len(bfs(grid, thead)[0].keys()) for thead in trailheads)

def part_2_solution(args):
    grid, trailheads = args

    return sum(bfs(grid, thead)[1] for thead in trailheads)


def transform_prompt():
    rows = Prompt.read_to_list(__file__)

    theads = []
    grid = []
    for y, row in enumerate(rows):
        nrow = []
        for x, c in enumerate(row):
            nrow.append(int(c))

            if c == '0':
                theads.append(Position2D(x, y))

        grid.append(nrow)

    return grid, theads