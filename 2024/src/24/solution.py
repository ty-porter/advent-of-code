from src.utils.prompt import Prompt

from collections import defaultdict
import copy

AND = lambda a, b: a & b
OR  = lambda a, b: a | b
XOR = lambda a, b: a ^ b

FUNCTIONS = {
    "AND": AND,
    "OR": OR,
    "XOR": XOR,
}

def simulate(wires, instructions):
    outputs = set()

    def resolve(wire):
        if wire in wires:
            return wires[wire]
        
        w1, inst, w2 = instructions[wire]
        wires[wire] = inst(resolve(w1), resolve(w2))

        return wires[wire]
    
    for output in instructions:
        resolve(output)

        if output[0] == 'z':
            outputs.add(output)

    bits = ''
    for output in reversed(sorted(outputs)):
        bits += str(wires[output])

    return int(bits, 2)

def part_1_solution(args):
    return simulate(*args)

def part_2_solution(_args):
    # Worked this problem by hand with debug statements
    return None


def transform_prompt():
    lines = Prompt.read_to_list(__file__)
    wires = defaultdict(int)
    instructions = {}

    for line in lines[:lines.index("")]:
        wire, bit = line.split(": ")

        wires[wire] = int(bit)

    for line in lines[lines.index("") + 1:]:
        w1, inst, w2, _arrow, out = line.split(" ")

        instructions[out] = (w1, FUNCTIONS[inst], w2)

    return wires, instructions