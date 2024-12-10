from src.prompt import Prompt
import copy, re

# . collides with ID = 47, so use the max Unicode code point
SPACE = chr(0x10FFFF)


def print_disk(label, disk):
    print(label, end=": ")
    for c in disk:
        if c == SPACE:
            print(".", end="")
        else:
            print(chr(ord(c) + ord("0")), end="")

    print("")


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

    checksum = 0

    for i, ID in enumerate(disk):
        if ID != SPACE:
            checksum += i * ord(ID)

    return checksum


def part_2_solution(_disk):
    # Must copy, we will be mutating it.
    disk = "".join(_disk)

    for block in reversed(list(re.finditer(rf"([^{SPACE}])\1*", disk))):
        if SPACE in block.group():
            continue

        size = block.end() - block.start()
        # This is a fun regex. Equivalent to /\.{size}/, but Python formatting is interesting.
        free_target = rf"{SPACE}{{{size}}}"

        if re.search(free_target, disk[: block.start()]):
            ID = block.group()[0]

            disk = re.sub(free_target, ID * size, disk, count=1)
            disk = disk[: block.start()] + re.sub(ID, SPACE, disk[block.start() :])

    checksum = 0

    for i, ID in enumerate(disk):
        if ID != SPACE:
            checksum += i * ord(ID)

    return checksum


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
