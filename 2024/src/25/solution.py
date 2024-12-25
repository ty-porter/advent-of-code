from src.utils.prompt import Prompt


def height(array):
    h = [None] * 5

    for y, line in enumerate(array):
        for i, c in enumerate(line):
            if c == "." and h[i] is None:
                h[i] = y - 1

    return h


def overlap(key, lock):
    for i, k in enumerate(key):
        if lock[i] + k > 5:
            return True

    return False


def part_1_solution(args):
    keys, locks = args

    s = 0
    for key in keys:
        for lock in locks:
            if overlap(key, lock):
                continue

            s += 1

    return s


def part_2_solution(_):
    # Christmas is already saved!
    return


def transform_prompt():
    lines = Prompt.read_to_list(__file__)
    keys = []
    locks = []

    for i in range(0, len(lines), 8):
        if lines[i] == "#####":
            locks.append(height(lines[i : i + 7]))
        else:
            keys.append(height(reversed(lines[i : i + 7])))

    return keys, locks
