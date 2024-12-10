from src.prompt import Prompt
import copy

# . collides with ID = 47, so use the max Unicode code point
SPACE = chr(0x10FFFF)

def part_1_solution(_disk):
    # Must copy, we will be mutating it.
    disk = copy.deepcopy(_disk)

    hptr = 0
    tptr = len(disk) - 1

    while hptr < tptr:
        head = disk[hptr]
        tail = disk[tptr]

        if head != SPACE:
            hptr += 1
            continue
        
        if tail == SPACE:
            tptr -= 1
            continue

        disk[hptr] = disk[tptr]
        disk[tptr] = SPACE

    total = 0

    for i, ID in enumerate(disk):
        if ID != SPACE:
            total += i * ord(ID)

    return total


def part_2_solution(disk):
    pass


def transform_prompt():
    raw_map = Prompt.read(__file__)
    disk = []

    ID = 0

    for i in range(0, len(raw_map), 2):
        if i == len(raw_map) - 1:
            free = 0
        else:
            free = int(raw_map[i + 1])

        blocks = chr(ID) * int(raw_map[i])
        spaces = SPACE * free

        disk.extend(list(blocks + spaces))
        ID += 1

    return disk
