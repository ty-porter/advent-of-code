from src.utils.prompt import Prompt

from collections import deque

ADD = lambda x, y: x + y
MUL = lambda x, y: x * y
CAT = lambda x, y: int(str(x) + str(y))


def bfs(numbers, target, operators):
    queue = deque([(numbers[0], 0)])

    while queue:
        value, index = queue.popleft()

        if index == len(numbers) - 1:
            if value == target:
                return True

            continue

        for op in operators:
            queue.append((op(value, numbers[index + 1]), index + 1))


def part_1_solution(equations):
    return sum(
        target for target, values in equations if bfs(values, target, [ADD, MUL])
    )


def part_2_solution(equations):
    return sum(
        target for target, values in equations if bfs(values, target, [ADD, MUL, CAT])
    )


def transform_prompt():
    out = []
    for row in Prompt.read_to_list(__file__):
        target, values = row.split(": ")

        out.append((int(target), [int(value) for value in values.split(" ")]))

    return out
