from src.prompt import Prompt
from dataclasses import dataclass
import copy


@dataclass
class DiskFragment:
    blocks: str
    free: int


def part_1_solution(args):
    disk, max_ID = args
    # Must copy, we will be deleting from this dict.
    disk = copy.deepcopy(disk)

    hptr = 0
    tptr = max_ID

    while hptr < tptr:
        head = disk[hptr]
        tail = disk[tptr]

        if head.free == 0:
            hptr += 1
            continue

        hfree = head.free
        tsize = len(tail.blocks)

        if hfree >= tsize:
            head.blocks += tail.blocks
            head.free -= tsize

            del disk[tptr]

            tptr -= 1

            disk[tptr].free += tsize
        else:
            head.blocks += tail.blocks[:hfree]
            head.free = 0

            tail.blocks = tail.blocks[: (tsize - hfree)]

    total = 0
    i = 0

    for _, frag in disk.items():
        for c in frag.blocks:
            total += i * ord(c)
            i += 1

    return total


def part_2_solution(disk):
    pass


def transform_prompt():
    raw_map = Prompt.read(__file__)
    disk_map = {}

    ID = 0

    for i in range(0, len(raw_map), 2):
        if i == len(raw_map) - 1:
            free = 0
        else:
            free = int(raw_map[i + 1])

        block = int(raw_map[i])
        disk_map[ID] = DiskFragment((str(chr(ID)) * block), free)
        ID += 1

    return disk_map, ID - 1
