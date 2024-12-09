from src.prompt import Prompt
import copy

def part_1_solution(args):
    disk, max_ID = args
    # Must copy, we will be deleting from this dict.
    disk = copy.deepcopy(disk)

    hptr = 0
    tptr = max_ID

    while hptr < tptr:
        head = disk[hptr]
        tail = disk[tptr]

        if head["free"] == 0:
            hptr += 1
            continue

        hfree = head["free"]
        tsize = len(tail["segment"])

        if hfree >= tsize:
            head["segment"] += tail["segment"]
            head["free"] -= tsize

            del disk[tptr]

            tptr -= 1

            disk[tptr]["free"] += tsize
        else:
            head["segment"] += tail["segment"][:hfree]
            head["free"] = 0

            tail["segment"] = tail["segment"][:(tsize - hfree)]
            
    total = 0
    i = 0

    for _, frag in disk.items():
        for c in frag["segment"]:
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
        disk_map[ID] = { "segment": (str(chr(ID)) * block), "free": free }
        ID += 1

    return disk_map, ID - 1
