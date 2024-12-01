from src.prompt import Prompt

def grid_vertices(grid):
  min_x, min_y, max_x, max_y = [None] * 4

  for point in grid:
    x, y = point

    if min_x == None:
      min_x, min_y, max_x, max_y = [x, y, x, y]
    else:
      min_x = min(min_x, x)
      min_y = min(min_y, y)
      max_x = max(max_x, x)
      max_y = max(max_y, y)

  return min_x, min_y, max_x, max_y

def grid_area(grid):
  x1, y1, x2, y2 = grid_vertices(grid)

  return (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)

def print_grid(grid):
  grid_array = []

  min_x, min_y, max_x, max_y = grid_vertices(grid)

  for y in range(max_y - min_y + 1):
    row = ""

    for x in range(max_x - min_x + 1):
      point = [min_x + x, min_y + y]
      if min_y < 0:
        point[1] += abs(min_y)
      
      if min_x < 0:
        point[0] += abs(min_x)

      if tuple(point) in grid:
        row += "#"
      else:
        row += "."

    grid_array.append(row)

  print(("\n").join(grid_array) + "\n")

def moves(x, y):
  spread = [-1, 0, 1]

  return {
    "N": ((x, y - 1), [(x + i, y - 1) for i in spread]),
    "S": ((x, y + 1), [(x + i, y + 1) for i in spread]),
    "W": ((x - 1, y), [(x - 1, y + i) for i in spread]),
    "E": ((x + 1, y), [(x + 1, y + i) for i in spread])
  }

def proposed_move(grid, x, y, order):
  possible_moves = moves(x, y)

  empty = []
  for direction in order:
    move, checks = possible_moves[direction]

    if all(check not in grid for check in checks):
      empty.append(move)

  if len(empty) == 4 or len(empty) == 0:
    return None

  return empty[0]

def part_1_solution(args):
  grid, elf_count = args
  order = ["N", "S", "W", "E"]

  for _ in range(10):
    proposed = {}

    for x, y in grid:
      move = proposed_move(grid, x, y, order)

      if move in proposed:
        proposed[move].append((x, y))
      else:
        proposed[move] = [(x, y)]

    for move in proposed:
      sources = proposed[move]

      if len(sources) > 1:
        continue

      grid[move] = 1
      grid.pop(sources[0])

    order = order[1:] + [order[0]]

  # Make sure I didn't drop any elves
  assert len(grid) == elf_count

  return grid_area(grid) - elf_count

def part_2_solution(args):
  grid, elf_count = args
  order = ["N", "S", "W", "E"]

  i = 0
  while i == 0 or moved:
    moved = False
    proposed = {}

    for x, y in grid:
      move = proposed_move(grid, x, y, order)

      if move in proposed:
        proposed[move].append((x, y))
      else:
        proposed[move] = [(x, y)]

    for move in proposed:
      sources = proposed[move]

      if len(sources) > 1 or move is None:
        continue

      grid[move] = 1
      grid.pop(sources[0])
      moved = True

    order = order[1:] + [order[0]]
    i += 1

  # Make sure I didn't drop any elves
  assert len(grid) == elf_count

  return i

def transform_prompt():
  grid = {}

  for y, line in enumerate(Prompt.read_to_list(__file__)):
    for x, char in enumerate(line):
      if char == "#":
        grid[(x, y)] = 1

  return grid, len(grid)

