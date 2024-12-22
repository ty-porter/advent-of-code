from src.utils.prompt import Prompt

from collections import Counter

def generate_secret_numbers(values):
    total = 0
    sequences = Counter()

    for value in values:
        v = int(value)
        o = None
        buf = []
        vseq = Counter()

        for i in range(2000):
            o = v
            v = (v ^ (v * 64)) % 16777216
            v = (v ^ (v // 32)) % 16777216
            v = (v ^ (v * 2048)) % 16777216

            if i >= 0:
                buf.append((v % 10) - (o % 10))

            if len(buf) > 4:
                buf.pop(0)

            if len(buf) == 4:
                if tuple(buf) not in vseq:
                    vseq[tuple(buf)] += v % 10

        total += v

        for seq, val in vseq.items():
            sequences[seq] += val

    return total, sequences

def part_1_solution(values):
    return generate_secret_numbers(values)[0]


def part_2_solution(values):
    _, sequences = generate_secret_numbers(values)

    return sequences[max(sequences, key=sequences.get)]


def transform_prompt():
    return Prompt.read_to_list(__file__)
