from src.prompt import Prompt
from src.utils import Position2D, Direction2D, CARDINAL_2D

from collections import deque

class Region:
    def __init__(self, letter, positions):
        self.letter = letter
        self.positions = positions

        self._perimeter = None
        self._sides = None
        self._bounding_box = None

    @property
    def price(self):
        return self.area * self.perimeter
    
    @property
    def side_price(self):
        return self.area * self.sides

    @property
    def area(self):
        return len(self.positions)

    @property
    def perimeter(self):
        if self._perimeter is not None:
            return self._perimeter

        total = 0

        for position in self.positions:
            perimeter = 4

            for d in CARDINAL_2D:
                if position + d in self.positions:
                    perimeter -= 1

            total += perimeter

        self._perimeter = total

        return total

    @property
    def sides(self):
        if self._sides is not None:
            return self._sides

        total = 0
        x1, y1, x2, y2 = self.bounding_box

        for y in range(y1, y2 + 1):
            for x in range(x1, x2 + 1):
                p = Position2D(x, y)
                total += self.internal_corners(p) + self.external_corners(p)

        return total
    
    @property
    def bounding_box(self):
        if self._bounding_box is not None:
            return self._bounding_box

        lx = ly = hx = hy = None

        for p in self.positions:
            if lx is None:
                lx = hx = p.x
                ly = hy = p.y

            lx = min(lx, p.x)
            hx = max(hx, p.x)
            ly = min(ly, p.y)
            hy = max(hy, p.y)

        self._bounding_box = (lx, ly, hx, hy)

        return self._bounding_box
    
    def internal_corners(self, p):
        if p in self.positions:
            return 0

        corner_directions = [
            [Direction2D.UP(), Direction2D.LEFT(), Direction2D.UP_LEFT()],
            [Direction2D.UP(), Direction2D.RIGHT(), Direction2D.UP_RIGHT()],
            [Direction2D.DOWN(), Direction2D.LEFT(), Direction2D.DOWN_LEFT()],
            [Direction2D.DOWN(), Direction2D.RIGHT(), Direction2D.DOWN_RIGHT()],
        ]

        total = 0

        for triplet in corner_directions:
            total += all(p + d in self.positions for d in triplet)
        
        return total

    def external_corners(self, p):
        if p not in self.positions:
            return 0

        neighbors = [p + d for d in CARDINAL_2D if p + d in self.positions]
        
        if len(neighbors) == 0:
            return 4

        if len(neighbors) == 1:
            return 2
        
        if len(neighbors) == 2:
            vec = neighbors[0] - neighbors[1]

            if abs(vec.x) > 1 or abs(vec.y) > 1:
                return 0
            
            return 1

        return 0


    @staticmethod
    def find(grid, x, y):
        target = grid[y][x]
        visited = { Position2D(x, y): 1 }
        found = {}
        queue = deque([Position2D(x, y)])

        while queue:
            position = queue.popleft()
            visited[position] = 1
            
            if grid[position.y][position.x] == target:
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
    return sum(region.side_price for region in regions)

def transform_prompt():
    grid = Prompt.read_to_grid(__file__)

    visited = {}
    regions = []

    for y, row in enumerate(grid):
        for x, _ in enumerate(row):
            if Position2D(x, y) in visited:
                continue

            region = Region.find(grid, x, y)
            regions.append(region)

            visited = visited | region.positions

    return regions
