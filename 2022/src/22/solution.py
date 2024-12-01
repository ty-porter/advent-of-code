from src.prompt import Prompt

import re

DIRECTIONS = {
  "r": ( 1,  0),
  "d": ( 0,  1),
  "l": (-1,  0),
  "u": ( 0, -1) 
}

CUBE = [
  {
    "a": {
      "range": tuple((51, 50 + i) for i in range(1, 51)),
      "from": "l",
      "to": "d",
    },
    "b": {
      "range": tuple((i, 101) for i in range(1, 51)),
      "from": "u",
      "to": "r",
    }
  },
  {
    "a": {
      "range": tuple((50, 150 + i) for i in range(1, 51)),
      "from": "r",
      "to": "u",
    },
    "b": {
      "range": tuple((i + 50, 150) for i in range(1, 51)),
      "from": "d",
      "to": "l",
    }
  },
  {
    "a": {
      "range": tuple((100, 50 + i) for i in range(1, 51)),
      "from": "r",
      "to": "u",
    },
    "b": {
      "range": tuple((i + 100, 50) for i in range(1, 51)),
      "from": "d",
      "to": "l",
    }
  },
  {
    "a": {
      "range": tuple((51, i) for i in range(1, 51)),
      "from": "l",
      "to": "r",
    },
    "b": {
      "range": tuple((1, i + 100) for i in range(50, 0, -1)),
      "from": "l",
      "to": "r",
    }
  },
  {
    "a": {
      "range": tuple((1, 150 + i) for i in range(1, 51)),
      "from": "l",
      "to": "d",
    },
    "b": {
      "range": tuple((i + 50, 1) for i in range(1, 51)),
      "from": "u",
      "to": "r",
    }
  },
  {
    "a": {
      "range": tuple((100, 100 + i) for i in range(1, 51)),
      "from": "r",
      "to": "l",
    },
    "b": {
      "range": tuple((150, i) for i in range(50, 0, -1)),
      "from": "r",
      "to": "l",
    }
  },
  {
    "a": {
      "range": tuple((i, 200) for i in range(1, 51)),
      "from": "d",
      "to": "d",
    },
    "b": {
      "range": tuple((i + 100, 1) for i in range(1, 51)),
      "from": "u",
      "to": "u",
    },
  },
]

def row(grid, row):
  return list(r[0] for r in grid if r[1] == row)

def col(grid, col):
  return list(c[1] for c in grid if c[0] == col)

def solution(args, cube=False):
  grid, wall, instructions = args

  position = (min(row(grid, 1)), 1)
  direction = "r"

  for inst in instructions:
    if isinstance(inst, int):
      for _ in range(inst):
        next_position = (position[0] + DIRECTIONS[direction][0], position[1] + DIRECTIONS[direction][1])
        next_direction = direction

        if next_position not in grid and cube == False:
          if direction == "r":
            next_position = (min(row(grid, position[1])), position[1])
          elif direction == "l":
            next_position = (max(row(grid, position[1])), position[1])
          elif direction == "u":
            next_position = (position[0], max(col(grid, position[0])))
          elif direction == "d":
            next_position = (position[0], min(col(grid, position[0])))
        elif next_position not in grid and cube == True:
          for edge in CUBE:
            for r in edge:
              current = edge[r]
              target = edge["a" if r == "b" else "b"]
              if position in current["range"] and direction == current["from"]:
                i = current["range"].index(position)
                next_direction = current["to"]
                next_position = target["range"][i]

        if next_position in wall:
          break
        position = next_position
        direction = next_direction

    else:
      idx = list(DIRECTIONS.keys()).index(direction)
      direction = list(DIRECTIONS.keys())[(idx + (1 if inst == "R" else -1)) % 4]

  return 1000 * position[1] + 4 * position[0] + list(DIRECTIONS.keys()).index(direction)

def part_1_solution(args):
  return solution(args)

def part_2_solution(args):
  return solution(args, cube=True)

def transform_prompt():
  lines = Prompt.read_to_list(__file__)

  grid = set()
  wall = set()

  instructions = list(int(val) if val.isdigit() else val for val in re.findall(r"(\d+|\D+)", lines[-1]))

  for row in range(1, len(lines) + 1):
    line = lines[row - 1]
    for col in range(1, len(line) + 1):
      cell = line[col - 1]

      if cell in [".", "#"]:
        grid.add((col, row))

      if cell == "#":
        wall.add((col, row))

  return grid, wall, instructions
