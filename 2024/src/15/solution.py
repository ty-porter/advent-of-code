from src.prompt import Prompt
from src.utils import Position2D, Direction2D, print_2d_grid

from collections import deque


DIRECTIONS = {
    '^': Direction2D.UP(),
    '>': Direction2D.RIGHT(),
    'v': Direction2D.DOWN(),
    '<': Direction2D.LEFT()
}

HORIZONTAL = [Direction2D.LEFT(), Direction2D.RIGHT()]
VERTICAL   = [Direction2D.UP(), Direction2D.DOWN()]


def furthest_movable(position, direction, obstacles, boxes):
    while position + direction not in obstacles:
        if position + direction not in boxes:
            return position

        position = position + direction
  
    return None

def width2_movables(position, direction, obstacles, boxes):
    if direction in HORIZONTAL:
        return width2_horizontal_movables(position, direction, obstacles, boxes)
    elif direction in VERTICAL:
        return width2_vertical_movables(position, direction, obstacles, boxes)
    else:
        raise RuntimeError(f"width2_movables requires cardinal direction, got: ", direction)

def width2_horizontal_movables(position, direction, obstacles, boxes):
    movables = []

    while position not in obstacles:
        movables.append(position)

        position = position + direction

        if position in obstacles:
            return []

        if position not in boxes:
            break

    # Bot moves last
    return list(reversed(movables))

def width2_vertical_movables(position, direction, obstacles, boxes):
    movables = []
    row = [position]

    while row:
        new_row = []
        for pos in row:
            if pos + direction in obstacles:
                return []
            
            movables.append(pos)
            
            if pos + direction in boxes:
                side = boxes[pos + direction]

                if side == '[':
                    new_row.append(pos + direction)
                    new_row.append(pos + direction + Direction2D.RIGHT())
                elif side == ']':
                    new_row.append(pos + direction + Direction2D.LEFT())
                    new_row.append(pos + direction)

        row = new_row

    # Bot moves last
    return list(reversed(movables))

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

def part_2_solution(args):
    _obstacles, _boxes, bot, instructions = args

    # Need to be re-parsed and expanded
    obstacles = {}
    boxes = {}
    bot.x *= 2

    max_x = 0
    max_y = 0
    for obstacle in _obstacles:
        left = Position2D(obstacle.x * 2, obstacle.y)
        right = left + Direction2D.RIGHT()

        obstacles[left] = '#'
        obstacles[right] = '#'

        if right.x > max_x:
            max_x = right.x
        if obstacle.y > max_y:
            max_y = obstacle.y

    for box in _boxes:
        left = Position2D(box.x * 2, box.y)
        right = left + Direction2D.RIGHT()

        boxes[left] = '['
        boxes[right] = ']'

    for instruction in instructions:
        direction = DIRECTIONS[instruction]

        # print("BOT AT: ", bot)
        movables = width2_movables(bot, direction, obstacles, boxes)
        # print(movables)

        for movable in movables:
            # print(movable)
            if movable == bot:
                # breakpoint()
                if movable in boxes:
                    del boxes[movable]

                bot += direction

            elif movable in boxes:
                boxes[movable + direction] = boxes[movable]

                if direction in VERTICAL:
                    del boxes[movable]
            elif direction == Direction2D.LEFT():
                boxes[movable + direction] = '['
            elif direction == Direction2D.RIGHT():
                boxes[movable + direction] = ']'

        # debug
        # grid = []
        # for y in range(max_y + 1):

        #     new_row = []

        #     for x in range(max_x + 1):
        #         if Position2D(x, y) in obstacles:
        #             new_row.append(obstacles[Position2D(x, y)])
        #         elif Position2D(x, y) in boxes:
        #             new_row.append(boxes[Position2D(x, y)])
        #         else:
        #             new_row.append('.')

        #     grid.append(new_row)
                
        # grid[bot.y][bot.x] = '@'

        # print_2d_grid(grid)
        # print()
        # end debug

    # total = 0
    # for box in boxes:
    #     # coord = min(box.y, max_y - box.y) * 100 + min(box.x, max_x - (box.x + 1))

    #     coord = box.y * 100 + box.x

    #     print("BOUNDS:", max_x, max_y)
    #     print("  VALUES:", box.y, max_y - box.y, box.x, max_x - (box.x + 1))

    #     if boxes[box] == '[':
    #         print("  SCORE:", box, boxes[box], coord)
    #         total += coord

    # return total

    
    return sum(box.y * 100 + box.x for box in boxes if boxes[box] == '[')


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
