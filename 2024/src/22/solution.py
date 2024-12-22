from src.utils.prompt import Prompt


def part_1_solution(values):
    s = 0
    for value in values:
        v = int(value)

        for _ in range(2000):
            v = (v ^ (v * 64)) % 16777216
            v = (v ^ (v // 32)) % 16777216
            v = (v ^ (v * 2048)) % 16777216

        s += v

    return s


def part_2_solution(values):
    return


def transform_prompt():
    return Prompt.read_to_list(__file__)
