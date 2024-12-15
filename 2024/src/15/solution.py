from src.prompt import Prompt
from src.utils import Position2D, Direction2D, print_2d_grid

import copy


DIRECTIONS = {
    '^': Direction2D.UP(),
    '>': Direction2D.RIGHT(),
    'v': Direction2D.DOWN(),
    '<': Direction2D.LEFT()
}

GRID1 = [[c for c in row] for row in [
    '########',
    '#......#',
    '##.....#',
    '#......#',
    '#.#....#',
    '#......#',
    '#......#',
    '########'
]]
GRID2 = [[c for c in row] for row in [
    '##########',
    '#........#',
    '#........#',
    '#........#',
    '#........#',
    '#.#......#',
    '#........#',
    '#........#',
    '#........#',
    '##########',
]]


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
        # print(bot, 'moving', direction, f'({instruction})', "to", bot + direction)

        movable = furthest_movable(bot, direction, obstacles, boxes)
        
        if movable is not None:
            bot = bot + direction
            if bot in boxes:
                # breakpoint()
                # print(f"removing bot {bot} from boxes")
                del boxes[bot]

            # if movable in boxes:
                boxes[movable + direction] = 1

        # BEGIN DEBUG
        # print("boxes:", boxes)
        # print("obstacles:", obstacles)
        
        # grid = copy.deepcopy(GRID2)

        # for box in boxes:
        #     try:
        #         grid[box.y][box.x] = 'O'
        #     except:
        #         # breakpoint()
        #         pass



        # grid[bot.y][bot.x] = '@'

        # print_2d_grid(grid)
        # print()

        # if instruction == '>':
        #     breakpoint()
         # END DEBUG

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

    # print(instructions)

    # instructions = lines[-1]

    return obstacles, boxes, bot, instructions
