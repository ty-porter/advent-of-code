class Color:
    RED = 31
    GREEN = 32
    YELLOW = 33
    BLUE = 34
    MAGENTA = 35
    CYAN = 36


class Coord:
    def __init__(self, x=0, y=0):
        self.x = x
        self.y = y

    def to_tuple(self):
        return (self.x, self.y)

    def __str__(self):
        return f"<Coord ({self.x}, {self.y})>"

    def __repr__(self):
        return self.__str__()


def colorize(text, color_code):
    return f"\033[{color_code}m{text}\033[0m"
