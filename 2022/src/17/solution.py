from src.prompt import Prompt

import numpy as np

HLINE = [[1, 1, 1, 1]]
PLUS = [
  [0, 1, 0],
  [1, 1, 1],
  [0, 1, 0]
]
J = [
  [0, 0, 1],
  [0, 0, 1],
  [1, 1, 1]
]
VLINE = [
  [1],
  [1],
  [1],
  [1]
]
SQUARE = [
  [1, 1],
  [1, 1]
]

SHAPES = [HLINE, PLUS, J, VLINE, SQUARE]

LEFT = -1
RIGHT = 1
DOWN = 1

START_X = 2
START_Y = 0

def next_shape(shape):
  current_index = SHAPES.index(shape)

  if current_index + 1 >= len(SHAPES):
    return SHAPES[0]
  else:
    return SHAPES[current_index + 1]

def pad(shape, x):
  lpad = [0] * x
  rpad = [0] * (7 - len(shape[0]) - x)

  return [lpad + line + rpad for line in shape]

def is_intersecting(grid, shape, x, y):
  if len(grid) > 0:
    target = np.array(pad(shape, x))
    grid_target = np.array(grid[y - len(shape) + 1:y + 1])

    intersection = np.where((target == grid_target), target, 0)

    return intersection.any()

  return False

def can_move(grid, shape, direction, x, y, vertical=False):
  if not vertical:
    if direction == LEFT and x > 0:
      return not is_intersecting(grid, shape, x + direction, y)
    elif direction == RIGHT and x + len(shape[0]) < 7:
      return not is_intersecting(grid, shape, x + direction, y)
  else:
    if y < len(grid) - 1:
      return not is_intersecting(grid, shape, x, y + DOWN)

  return False

def pad_grid(grid, shape):
  needed = len(shape) + 3 - padding(grid)

  if needed > 0:
    for _ in range(needed):
      grid.insert(0, [0 for _ in range(7)])
  elif needed < 0:
    for _ in range(abs(needed)):
      grid.pop(0)

def padding(grid):
  return sum(1 if sum(line) == 0 else 0 for line in grid)

def height(grid):
  return len(grid) - padding(grid)

def print_grid(grid):
  for line in grid:
    print("".join("." if value == 0 else "#" for value in line))

  print("\n")

def simulate(jets, limit=2022):
  shapes_settled = 0
  j = 0
  shape = SHAPES[0]

  grid = []
  pad_grid(grid, shape)

  pos = [START_X, len(shape) - 1]
  previously_blocked = False

  tracked = {}

  while shapes_settled < limit:
    key = (j % len(jets), SHAPES.index(shape))

    if key in tracked:
      prev_shapes_settled, prev_height = tracked[key]
      period = shapes_settled - prev_shapes_settled

      if shapes_settled % period == limit % period:
        cycle_height = height(grid) - prev_height
        shapes_remaining = limit - shapes_settled
        cycles_remaining = (shapes_remaining // period)

        return height(grid) + (cycle_height * cycles_remaining)
    else:
      tracked[key] = (shapes_settled, height(grid))

    direction = LEFT if jets[j % len(jets)] == '<' else RIGHT
    j += 1

    # Horizontal collision
    if can_move(grid, shape, direction, *pos):
      pos[0] += direction

    # Vertical collision
    blocked = not can_move(grid, shape, DOWN, *pos, vertical=True)
    if not blocked:
      pos[1] += DOWN
      previously_blocked = False
    else:
      previously_blocked = True

    if blocked and previously_blocked:
      for y, line in enumerate(reversed(shape)):
        for x, value in enumerate(line):
          if value:
            grid[pos[1] - y][pos[0] + x] = value

      shape = next_shape(shape)
      pos = [START_X, len(shape) - 1]
      shapes_settled += 1

      pad_grid(grid, shape)

  return height(grid)

def part_1_solution(jets):
  return simulate(jets)

def part_2_solution(jets):
  return simulate(jets, limit=1_000_000_000_000)

def transform_prompt():
  return Prompt.read(__file__)