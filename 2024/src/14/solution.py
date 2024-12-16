from src.utils.prompt import Prompt
from src.utils.plane import Position2D, Vec2


X = 101
Y = 103

MID_X = X // 2
MID_Y = Y // 2


class Bot:
    def __init__(self, position, velocity):
        self.position = position
        self.velocity = velocity


def part_1_solution(bots):
    for _ in range(100):
        for bot in bots:
            bot.position += bot.velocity
            bot.position.x %= X
            bot.position.y %= Y

    quadrants = [0, 0, 0, 0]

    for bot in bots:
        # Top
        if bot.position.y < MID_Y:
            # Left
            if bot.position.x < MID_X:
                quadrants[0] += 1
            # Right
            elif bot.position.x > MID_X:
                quadrants[1] += 1

        # Bottom
        elif bot.position.y > MID_Y:
            # Left
            if bot.position.x < MID_X:
                quadrants[2] += 1
            # Right
            elif bot.position.x > MID_X:
                quadrants[3] += 1

    total = 1
    for quadrant in quadrants:
        total *= quadrant

    return total


def part_2_solution(bots):
    found = -1
    cluster_score = 1e10

    for iteration in range(1, X * Y + 1):
        score = 0

        for bot in bots:
            bot.position += bot.velocity
            bot.position.x %= X
            bot.position.y %= Y

            score += bot.position.manhattan_distance(Position2D(MID_X, MID_Y))

        if score < cluster_score:
            cluster_score = score
            found = iteration

    return found


def transform_prompt():
    bots = []

    for line in Prompt.read_to_list(__file__):
        pos, vel = line.split(" ")

        pos = pos.replace("p=", "")
        vel = vel.replace("v=", "")

        bots.append(
            Bot(
                Position2D(*[int(p) for p in pos.split(",")]),
                Vec2(*[int(v) for v in vel.split(",")]),
            )
        )

    return bots
