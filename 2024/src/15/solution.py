from src.prompt import Prompt
from src.utils import Position2D, Direction2D


DIRECTIONS = {
    '^': Direction2D.UP(),
    '>': Direction2D.RIGHT(),
    'v': Direction2D.DOWN(),
    '<': Direction2D.LEFT()
}


def furthest_movable(position, direction, obstacles, boxes):
    while position + direction not in obstacles:
        if position + direction not in boxes:
            return position

        position = position + direction
  
    return None

def part_1_solution(args):
    obstacles, boxes, bot, instructions = args

    for instruction in instructions:
        direction = DIRECTIONS[instruction]

        movable = furthest_movable(bot, direction, obstacles, boxes)
        
        if movable is not None:
            bot = bot + direction
            if bot in boxes:
                del boxes[bot]

                boxes[movable + direction] = 1

    return sum(box.y * 100 + box.x for box in boxes)

def part_2_solution(values):
    return


def transform_prompt():
    lines = Prompt.read_to_list(__file__)

    obstacles = {}
    boxes = {}
    bot = None

    for y, row in enumerate(lines):
        if row == '':
            instructions = ''.join(lines[y + 1:len(lines)])
            break

        for x, col in enumerate(row):
            if col == '#':
                obstacles[Position2D(x, y)] = 1
            elif col == 'O':
                boxes[Position2D(x, y)] = 1
            elif col == '@':
                bot = Position2D(x, y)

    return obstacles, boxes, bot, instructions
