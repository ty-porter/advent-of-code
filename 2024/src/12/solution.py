from src.prompt import Prompt
from src.utils import Position2D, Direction2D, CARDINAL_2D_CW

from collections import deque

class Region:
    def __init__(self, letter, positions, start):
        self.letter = letter
        self.positions = positions

        # By iteration order this will always be a top left corner.
        self.start = start

        self._perimeter = None
        self._sides = None

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

            for d in CARDINAL_2D_CW:
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

        # Assumption: Start is top left of region
        tgt_dir = Direction2D.DOWN()
        move_dir = Direction2D.RIGHT()
        pos = self.start + Direction2D.UP()

        while True:
            while pos + tgt_dir in self.positions and pos + move_dir not in self.positions:
                pos += move_dir

            total += 1

            # Store a temp direction to swap movement/target
            tmp_dir = move_dir

            # Shape is concave at side (pointer hit a wall)
            if pos + move_dir in self.positions:
                # Turn to face the opposite of the old target
                move_dir = tgt_dir.turn180()
                # Movement direction was orthogonal to the target already
                tgt_dir = tmp_dir
            # Shape is convex at side
            elif pos + tgt_dir not in self.positions:
                # breakpoint()
                # Old target is the new direction of movement
                move_dir = tgt_dir
                # Movement direction was orthogonal to the target already, target will be opposite
                tgt_dir = tmp_dir.turn180()

            pos += move_dir

            # Completed a cycle around the region
            if pos == self.start + Direction2D.UP():
                break

        self._sides = total

        return total


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

            for d in CARDINAL_2D_CW:
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

        return Region(target, found, Position2D(x, y))

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
