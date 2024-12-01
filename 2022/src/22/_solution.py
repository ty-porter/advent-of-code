from src.prompt import Prompt

import re

DIRECTIONS = [
  ( 1,  0), # Right
  ( 0,  1), # Down
  (-1,  0), # Left
  ( 0, -1)  # Up
]

def next_position(grid, x, y, amt, direction):
  prv_valid_position = [x, y]
  next_y = (y + direction[1]) % len(grid)
  next_x = (x + direction[0]) % len(grid[next_y])
  next_position = [next_x, next_y]
  cell = grid[next_position[1]][next_position[0]]

  for _ in range(amt - 1):
    if cell == "#":
      return prv_valid_position
    elif cell == ".":
      grid[next_position[1]][next_position[0]] = '>v<^'[DIRECTIONS.index(direction)]
      prv_valid_position = next_position
      next_y = (next_position[1] + direction[1]) % len(grid)
      next_x = (next_position[0] + direction[0]) % len(grid[next_y])
      next_position = [next_x, next_y]
      cell = grid[next_position[1]][next_position[0]]
    else:
      while cell == " ":
        next_y = (next_position[1] + direction[1]) % len(grid)
        next_x = (next_position[0] + direction[0]) % len(grid[next_y])
        next_position = [next_x, next_y]
        cell = grid[next_position[1]][next_position[0]]

        if grid[next_position[1]][next_position[0]] == "#":
          return prv_valid_position

  return next_position

def next_direction(direction, instruction):
  idx = DIRECTIONS.index(direction)

  if instruction == "L":
    idx -= 1
  else:
    idx = (idx + 1) % len(DIRECTIONS)

  return DIRECTIONS[idx]

def part_1_solution(values):
  grid, instructions = values

  position = [grid[0].index("."), 0]
  grid[position[1]][position[0]] = "O"
  direction = DIRECTIONS[0]

  for instruction in instructions:
    if isinstance(instruction, int):
      print(f"Instruction {instruction}: moving {instruction} units {'>v<^'[DIRECTIONS.index(direction)]}")
      position = next_position(grid, *position, instruction, direction)
    else:
      pdir = direction
      direction = next_direction(direction, instruction)
      grid[position[1]][position[0]] = '>v<^'[DIRECTIONS.index(direction)]
      print(f"Instruction {instruction}: turned from {'>v<^'[DIRECTIONS.index(pdir)]} to {'>v<^'[DIRECTIONS.index(direction)]}")

  #   for line in grid:
  #     print("".join(line))

  # print(position, DIRECTIONS.index(direction))
  return (1000 * (position[1] + 1)) + (4 * (position[0] + 1)) + DIRECTIONS.index(direction)

def part_2_solution(values):
  return

def transform_prompt():
  lines = Prompt.read_to_list(__file__)#, test=True)

  max_len = 0
  for line in lines:
    max_len = max(max_len, len(line))

  instructions = list(int(val) if val.isdigit() else val for val in re.findall(r"(\d+|\D+)", lines[-1]))
  grid = [[char for char in line] for line in lines[:-2]]

  return grid, instructions
