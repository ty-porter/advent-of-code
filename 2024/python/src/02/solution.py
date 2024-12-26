from src.utils.prompt import Prompt


def is_invalid(delta, direction):
    return (
        delta == 0
        or abs(delta) > 3
        or direction is not None
        and direction != delta / abs(delta)
    )


def process_report(report):
    direction = None

    for i in range(0, len(report) - 1):
        delta = report[i] - report[i + 1]

        if is_invalid(delta, direction):
            return False

        if direction is None and delta != 0:
            direction = delta / abs(delta)

    return True


def part_1_solution(reports):
    return sum(process_report(report) for report in reports)


def part_2_solution(reports):
    total = 0

    for report in reports:
        if process_report(report):
            total += 1
            continue

        for x in range(0, len(report)):
            fixed_report = [n for i, n in enumerate(report) if i != x]

            if process_report(fixed_report):
                total += 1
                break

    return total


def transform_prompt():
    return [[int(n) for n in line.split(" ")] for line in Prompt.read_to_list(__file__)]
