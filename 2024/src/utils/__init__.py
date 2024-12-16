import argparse

from functools import wraps

parser = argparse.ArgumentParser(prog="Advent of Code 2024")
parser.add_argument("solution", type=int, nargs="?")
parser.add_argument("--no-skip", type=str, nargs="*")

cliargs = parser.parse_args()


class Color:
    RED = 31
    GREEN = 32
    YELLOW = 33
    BLUE = 34
    MAGENTA = 35
    CYAN = 36

def colorize(text, color_code):
    return f"\033[{color_code}m{text}\033[0m"


def skippable(ID):
    def decorator(func):
        @wraps(func)
        def wrapper(*args, **kwargs):
            if cliargs.no_skip is None or (
                len(cliargs.no_skip) > 0 and ID not in cliargs.no_skip
            ):
                return f"< Skipped >\tPass --no-skip {ID} to run."

            return func(*args, **kwargs)

        return wrapper

    return decorator
