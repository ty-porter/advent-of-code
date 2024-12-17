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
    @staticmethod
    def UP():
        return Direction2D(0, -1)

    @staticmethod
    def DOWN():
        return Direction2D(0, 1)

    @staticmethod
    def LEFT():
        return Direction2D(-1, 0)

    @staticmethod
    def RIGHT():
        return Direction2D(1, 0)

    # B A B A Start -- Infinite lives

    @staticmethod
    def UP_RIGHT():
        return Direction2D(1, -1)

    @staticmethod
    def DOWN_RIGHT():
        return Direction2D(1, 1)

    @staticmethod
    def UP_LEFT():
        return Direction2D(-1, -1)

    @staticmethod
    def DOWN_LEFT():
        return Direction2D(-1, 1)

    def turn90CW(self):
        return Direction2D(self.y, -self.x)

    def turn90CCW(self):
        return Direction2D(-self.y, self.x)

    def turn180(self):
        return Direction2D(-self.x, -self.y)


class Position2D(Vec2):
    def manhattan_distance(self, other):
        return abs(self.x - other.x) + abs(self.y - other.y)


# Cardinal directions
CARDINAL_2D = [
    Direction2D.UP(),
    Direction2D.RIGHT(),
    Direction2D.DOWN(),
    Direction2D.LEFT(),
]

# Cardinal directions (clockwise)
CARDINAL_2D_CW = CARDINAL_2D
# Cardinal directions (counter-clockwise)
CARDINAL_2D_CCW = CARDINAL_2D[::-1]

# Diagonal directions
DIAGONAL_2D = [
    Direction2D.DOWN_RIGHT(),
    Direction2D.UP_LEFT(),
    Direction2D.UP_RIGHT(),
    Direction2D.DOWN_RIGHT(),
]


def generate_grid(x, y, default=" "):
    return [[default for _ in range(x)] for _ in range(y)]


def print_2d_grid(grid, sep=""):
    for row in grid:
        print(sep.join(str(c) for c in row))
