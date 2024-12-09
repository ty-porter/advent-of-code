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


class Vec2:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def __eq__(self, other):
        if isinstance(other, self.__class__):
            return (self.x, self.y) == (other.x, other.y)

        return False

    def __hash__(self):
        return hash((self.x, self.y))

    def __add__(self, other):
        if not isinstance(other, Vec2):
            return NotImplemented

        if isinstance(self, Position2D) or isinstance(other, Position2D):
            result_class = Position2D
        else:
            result_class = self.__class__

        return result_class(self.x + other.x, self.y + other.y)

    def __sub__(self, other):
        if not isinstance(other, Vec2):
            return NotImplemented

        if isinstance(self, Position2D) or isinstance(other, Position2D):
            result_class = Position2D
        else:
            result_class = self.__class__

        return result_class(self.x - other.x, self.y - other.y)

    def to_tuple(self):
        return (self.x, self.y)

    def __str__(self):
        return f"<{self.__class__.__name__} ({self.x}, {self.y})>"

    def __repr__(self):
        return self.__str__()

    def __id__(self):
        return self.__str__()


class Direction2D(Vec2):
    pass


class Position2D(Vec2):
    pass


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


def print_2d_grid(grid, sep=""):
    for row in grid:
        print(sep.join(row))
