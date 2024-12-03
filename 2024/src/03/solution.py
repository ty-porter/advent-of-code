from src.prompt import Prompt

import re

MUL = re.compile("mul\((\d+),(\d+)\)")
INST = re.compile("(do|don't)\(\)")


def part_1_solution(mem):
    return sum(
        int(match.group(1)) * int(match.group(2)) for match in re.finditer(MUL, mem)
    )


def part_2_solution(mem):
    mods = [(0, True)] + [
        (match.span()[0], match.group() == "do()") for match in re.finditer(INST, mem)
    ]
    muls = [
        (match.span()[0], int(match.group(1)), int(match.group(2)))
        for match in re.finditer(MUL, mem)
    ]

    modptr = 0
    mod = mods[modptr]

    total = 0

    for mul in muls:
        nextmod = None

        if modptr < len(mods) - 1:
            nextmod = mods[modptr + 1]

        if nextmod and nextmod[0] < mul[0]:
            mod = nextmod
            modptr += 1

        if mod[1]:
            total += mul[1] * mul[2]

    return total


def transform_prompt():
    return Prompt.read(__file__)
