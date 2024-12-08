from src.prompt import Prompt
from src.utils import Position2D

def inbounds(pos, bounds):
    return pos.x >= 0 and pos.x < bounds.x and pos.y >= 0 and pos.y < bounds.y

def generate_antinodes(p1, p2, bounds):
    def _generate(p1, p2, bounds):
        delta = p1 - p2
        pos = p1 + delta

        out = [p1]
        while inbounds(pos, bounds):
            out.append(pos)
            pos += delta

        return out

    return _generate(p1, p2, bounds) + _generate(p2, p1, bounds)

def part_1_solution(args):
    antennae, bounds = args

    antinodes = {}

    for ant in antennae:
        for i, a1pos in enumerate(antennae[ant]):
            for j, a2pos in enumerate(antennae[ant]):
                if i == j:
                    continue

                if ant not in antinodes:
                    antinodes[ant] = {}

                antinodes[ant][a1pos + (a1pos - a2pos)] = 1
                antinodes[ant][a2pos + (a2pos - a1pos)] = 1

    valid_antinodes = {}
    for antenna in antinodes:
        for antinode in antinodes[antenna]:
            if inbounds(antinode, bounds):
                valid_antinodes[antinode] = 1

    return len(valid_antinodes)

def part_2_solution(args):
    antennae, bounds = args

    antinodes = {}

    for ant in antennae:
        for i, a1pos in enumerate(antennae[ant]):
            for j, a2pos in enumerate(antennae[ant]):
                if i == j:
                    continue

                if ant not in antinodes:
                    antinodes[ant] = {}

                for antinode in generate_antinodes(a1pos, a2pos, bounds):
                    antinodes[ant][antinode] = 1

    valid_antinodes = {}
    for antenna in antinodes:
        for antinode in antinodes[antenna]:
            if inbounds(antinode, bounds):
                valid_antinodes[antinode] = 1

    return len(valid_antinodes)


def transform_prompt():
    grid = Prompt.read_to_grid(__file__)

    ant = {}

    for y, row in enumerate(grid):
        for x, c in enumerate(row):
            if c != '.':
                if c in ant:
                    ant[c].append(Position2D(x, y))
                else:
                    ant[c] = [Position2D(x, y)]

    return ant, Position2D(len(grid), len(grid[0]))
