from src.utils.prompt import Prompt
from src.utils.plane import Position2D

WALL = '#'
START = 'S'
FINISH = 'E'

def distance_along_path(start, position, bounds, walls):
    distances = {}
    distance = 0
    while position != start:
        distances[position] = distance

        distance += 1
        
        for neighbor in position.cardinal_neighbors():
            if neighbor.x < 0 or neighbor.y < 0:
                continue
            if neighbor.x > bounds.x or neighbor.y > bounds.y:
                continue
            if neighbor in walls:
                continue
            if neighbor in distances:
                continue

            position = neighbor

    distances[start] = distance

    return distances

def valid_cheats(distances, max_dist, cheat_threshold):
    total = 0

    for p1, d1 in distances.items():
        for p2, d2 in distances.items():
            if p1 == p2:
                continue
            
            dist = p1.manhattan_distance(p2)
            if dist < 2 or dist > max_dist:
                continue

            cheat = abs(d1 - d2)

            if cheat >= cheat_threshold:
                total += 1
    
    return total


def part_1_solution(args):
    start, finish, bounds, walls = args

    distances = distance_along_path(start, finish, bounds, walls)

    total = 0
    for position in distances:
        for wall in position.cardinal_neighbors():
            found = 0
            for neighbor in wall.cardinal_neighbors():
                if neighbor in walls:
                    continue
                if neighbor not in distances:
                    continue
                
                if distances[position] - distances[neighbor] > 100:
                    found = 1
            
            total += found

    return total

def part_2_solution(values):
    return


def transform_prompt():
    walls = {}

    bounds = Position2D(-1, -1)
    for y, row in enumerate(Prompt.read_to_list(__file__)):
        for x, col in enumerate(row):
            if col == WALL:
                walls[Position2D(x, y)] = WALL
            elif col == START:
                start = Position2D(x, y)
            elif col == FINISH:
                finish = Position2D(x, y)

            bounds.x = max(x, bounds.x)
            bounds.y = max(y, bounds.y)

    return start, finish, bounds, walls