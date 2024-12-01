from src.prompt import Prompt

def solution(args, step=1):
  grid, height, width, start, stop = args
  positions = set([start])

  while True:
    next_positions = set()
    for r, c in positions:
      for x, y in ((r, c), (r - 1, c), (r + 1, c), (r, c - 1), (r, c + 1)):
        if (x, y) == stop:
          return step
        if 0 <= x < height and 0 <= y < width \
          and grid[x][(y - step) % width] != ">" \
          and grid[x][(y + step) % width] != "<" \
          and grid[(x - step) % height][y] != "v" \
          and grid[(x + step) % height][y] != "^":
          next_positions.add((x, y))
    positions = next_positions
    if not positions:
      positions.add(start)
    step += 1

def part_1_solution(args):
  return solution(args)

def part_2_solution(args):
  return solution(args, step=solution(args, step=solution(args)))

def transform_prompt():
  rows = Prompt.read_to_list(__file__)[1:-1]

  grid = [row[1:-1] for row in rows]
  height, width = len(grid), len(grid[0])
  start, stop = (-1, 0), (height, width - 1)

  return grid, height, width, start, stop
