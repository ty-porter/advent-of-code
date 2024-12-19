from src.utils.prompt import Prompt
from functools import cache

from queue import PriorityQueue


def part_1_solution(args):
    patterns, designs = args

    total = 0
    for design in designs:
        pq = PriorityQueue()
        for pattern in patterns:
            pq.put((len(design), pattern, design))

        while not pq.empty():
            _sz, pat, des = pq.get()

            if pat == des:
                total += 1
                break

            if not des.startswith(pat):
                continue

            next_des = des[len(pat) :]
            next_sz = len(next_des)

            for next_pat in patterns:
                if not next_des.startswith(next_pat):
                    continue

                pq.put((next_sz, next_pat, next_des))

    return total


def part_2_solution(args):
    patterns, designs = args

    @cache
    def permutations(design):
        total = 0

        for pattern in patterns:
            if pattern == design:
                total += 1

            if design.startswith(pattern):
                l = len(pattern)
                total += permutations(design[l:])

        return total

    return sum(permutations(design) for design in designs)


def transform_prompt():
    patterns, _, *design = Prompt.read_to_list(__file__)
    patterns = [pattern for pattern in patterns.split(", ")]

    return patterns, design
