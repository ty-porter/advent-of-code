from src.utils.prompt import Prompt
from functools import cache

from queue import PriorityQueue


def part_1_solution(args):
    patterns, designs = args

    total = 0
    for design in designs:
        found = 0
        pq = PriorityQueue()
        for pattern in patterns:
            pq.put((len(design), pattern, design))

        while not pq.empty():
            sz, pat, des = pq.get()

            if pat == des:
                found = 1
                break

            if pat != des[: len(pat)] or len(pat) > sz:
                continue

            next_des = des[len(pat) :]
            next_sz = len(next_des)

            for next_pat in patterns:
                if next_pat != next_des[: len(next_pat)] or len(next_pat) > next_sz:
                    continue

                pq.put((next_sz, next_pat, next_des))

        total += found

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
