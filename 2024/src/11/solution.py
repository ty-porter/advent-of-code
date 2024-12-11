from src.prompt import Prompt


def apply_rules(value):
    if value == 0:
        return [1]

    if len(str(value)) % 2 == 0:
        st = str(value)

        return [int(st[: len(st) // 2]), int(st[len(st) // 2 :])]

    return [value * 2024]


def blink(stones, limit):
    frequency = {}

    for stone in stones:
        if stone not in frequency:
            frequency[stone] = 0

        frequency[stone] += 1

    for _ in range(limit):
        new_freq = {}

        for stone, freq in frequency.items():
            for new_stone in apply_rules(stone):
                if new_stone not in new_freq:
                    new_freq[new_stone] = 0

                new_freq[new_stone] += freq

        frequency = new_freq

    return sum(freq for _, freq in frequency.items())


def part_1_solution(stones):
    return blink(stones, 25)


def part_2_solution(stones):
    return blink(stones, 75)


def transform_prompt():
    return [(int(n)) for n in Prompt.read(__file__).split(" ")]
