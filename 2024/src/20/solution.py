from src.utils.prompt import Prompt
from src.utils.plane import Position2D

WALL = '#'
START = 'S'
FINISH = 'E'

def race(start, position, bounds, walls):
    route = []
    visited = {}

    distance = 0

    while position != start:
        if position in visited:
            continue

        visited[position] = 1

        route.append((position, distance))
        distance += 1
        
        for neighbor in position.cardinal_neighbors():
            if neighbor.x < 0 or neighbor.y < 0:
                continue
            if neighbor.x > bounds.x or neighbor.y > bounds.y:
                continue
            if neighbor in walls:
                continue
            if neighbor in visited:
                continue

            position = neighbor

    route.append((start, distance))

    return route

def valid_cheats(route, max_dist, threshold):
    total = 0

    for i, pair in enumerate(route):
        for j in range(i + 1, len(route)):
            p1, d1 = pair
            p2, d2 = route[j]

            dist = p1.manhattan_distance(p2)
            if dist > max_dist:
                continue

            cheat = d2 - d1 - dist

            if cheat >= threshold:
                total += 1
    
    return total


def part_1_solution(args):
    return valid_cheats(race(*args), 2, 100)

def part_2_solution(args):
    return valid_cheats(race(*args), 20, 100)

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