from src.prompt import Prompt
from src.utils import Vec2

import re

A = 3
B = 1

def solve(a, b, p):
    det = a.x * b.y - a.y * b.x

    if det == 0:
        return 0

    ap = (b.x * p.y - b.y * p.x) / det
    bp = (a.x * p.y - a.y * p.x) / det

    if int(ap) == ap and int(bp) == bp:
        return int(abs(ap * A) + abs(bp * B))
    
    return 0

def part_1_solution(machines):
    return sum(solve(a, b, p) for a, b, p in machines)

def part_2_solution(machines):
    return sum(solve(a, b, p + Vec2(1e13, 1e13)) for a, b, p in machines)


def transform_prompt():
    parsed_machines = []

    machines = Prompt.read_to_list(__file__)
    for m in range(0, len(machines) + 1, 4):
        a, b, p = machines[m : m + 3]

        parse_nums = lambda s: list(int(d) for d in re.findall("\d+", s))

        button_a = Vec2(*parse_nums(a))
        button_b = Vec2(*parse_nums(b))
        prize = Vec2(*parse_nums(p))
        parsed_machines.append((button_a, button_b, prize))

    return parsed_machines
