from src.prompt import Prompt
from src.utils import Position2D, CARDINAL_2D

from collections import deque

class Region:
    def __init__(self, letter, positions):
        self.letter = letter
        self.positions = positions

    @property
    def price(self):
        return self.area * self.perimeter

    @property
    def area(self):
        return len(self.positions)
    
    @property
    def perimeter(self):
        total = 0

        for position in self.positions:
            perimeter = 4

            for d in CARDINAL_2D:
                if position + d in self.positions:
                    perimeter -= 1

            total += perimeter

        return total

    def __str__(self):
        return f"<Region {self.letter} (price: {self.price}, area: {self.area}, perimeter: {self.perimeter})>"
    
    def __repr__(self):
        return self.__str__()

    @staticmethod
    def find(grid, x, y):
        target = grid[y][x]
        visited = { Position2D(x, y): 1 }
        found = {}
        queue = deque([Position2D(x, y)])

        while queue:
            position = queue.popleft()
            visited[position] = 1
            
            if grid[y][x] == target:
                found[position] = 1

            for d in CARDINAL_2D:
                p = position + d
                
                y_in_bound = p.y >= 0 and p.y < len(grid)
                x_in_bound = p.x >= 0 and p.x < len(grid[0])

                if not y_in_bound or not x_in_bound:
                    continue

                if grid[p.y][p.x] != target:
                    continue

                if p not in visited:
                    visited[p] = 1
                    queue.append(p)

        return Region(target, found)

def part_1_solution(regions):
    return sum(region.price for region in regions)

def part_2_solution(regions):
    return


def transform_prompt():
    grid = Prompt.read_to_grid(__file__)

    visited = {}
    regions = []

    for y, row in enumerate(grid):
        for x, _ in enumerate(row):
            if Position2D(x, y) in visited:
                continue

            region = Region.find(grid, x, y)

            visited = visited | region.positions

            regions.append(region)

    return regions
