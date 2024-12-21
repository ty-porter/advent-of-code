from src.utils.prompt import Prompt
from src.utils import skippable

from functools import cache

KP_PATH = {
    ('A', '<'): 'v<<',
    ('A', '>'): 'v',
    ('A', 'v'): '<v',
    ('A', '^'): '<',
    ('<', 'A'): '>>^',
    ('<', '^'): '>^',
    ('<', 'v'): '>',
    ('<', '>'): '>>',
    ('>', 'A'): '^',
    ('>', '^'): '<^',
    ('>', 'v'): '<',
    ('>', '<'): '<<',
    ('^', 'A'): '>',
    ('^', '<'): 'v<',
    ('^', '>'): 'v>',
    ('^', 'v'): 'vv',
    ('v', 'A'): '^>',
    ('v', '>'): '>',
    ('v', '<'): '<',

    ('A', '0'): '<',
    ('A', '1'): '^<<',
    ('A', '3'): '^',
    ('A', '4'): '^^<<',
    ('A', '5'): '^^<',
    ('A', '6'): '^^',
    ('A', '7'): '^^^<<',
    ('A', '9'): '^^^',
    ('0', '2'): '^',
    ('0', 'A'): '>',
    ('1', 'A'): '>>v',
    ('1', '7'): '^^',
    ('1', '9'): '^^>>',
    ('2', 'A'): 'v>',
    ('2', '9'): '^^>',
    ('3', 'A'): 'v',
    ('3', '1'): '<<',
    ('3', '5'): '<^',
    ('3', '7'): '<<^^',
    ('3', '8'): '<^^',
    ('4', '0'): 'vv>',
    ('4', '5'): '>',
    ('4', '6'): '>>',
    ('4', '8'): '^>',
    ('5', 'A'): 'vv>',
    ('5', '4'): '<',
    ('5', '6'): '>',
    ('6', 'A'): 'vv',
    ('6', '3'): 'v',
    ('6', '7'): '<<^',
    ('7', '1'): 'vv',
    ('7', '6'): 'v>>',
    ('7', '6'): 'v>>',
    ('7', '8'): '>',
    ('7', '9'): '>>',
    ('8', '0'): 'vvv',
    ('8', '2'): 'vv',
    ('8', '5'): 'v',
    ('9', '8'): '<'
}

@cache
def encode(seq):
    current = 'A'
    out = []
    for button in seq:
        if current == button:
            out.append('A')
            continue

        out.append(KP_PATH[(current, button)] + 'A')
        current = button

    return out

def complexity(codes, robots):
    total = 0
    for code in codes:
        sequences = [code]
        for _ in range(robots):
            next_sequences = []
            for seq in sequences:
                next_sequences.extend(encode(seq))

            sequences = next_sequences

        total += len("".join(sequences)) * int(code[:3])

    return total

def part_1_solution(codes):
    return complexity(codes, 3)

@skippable("21p2")
def part_2_solution(codes):
    return complexity(codes, 26)


def transform_prompt():
    return Prompt.read_to_list(__file__)
