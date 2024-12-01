from src.prompt import Prompt

import queue, string

H = string.ascii_lowercase

def neighbors(grid, x, y):
  results = []

  coords = [
      [x - 1, y    ],
      [x + 1, y    ],
      [x    , y - 1],
      [x    , y + 1]
    ]

  for coord in coords:
    if coord[0] >= 0 and coord[1] >= 0:
      try:
        valid = True if at(grid, *coord) is not None else False
      except:
        valid = None

      if valid:
        results.append((coord[0], coord[1]))
      
  return results

def at(grid, x, y):
  return grid[y][x]

def dijkstra(args):
  grid, initial, target = args
  visited = set()
  pqueue = queue.PriorityQueue()

  pqueue.put((0, (initial, [])))

  while not pqueue.empty():
    steps, data = pqueue.get()
    position, path = data

    if position == target:
      return steps

    if position not in visited:
      visited.add(position)
      for neighbor in neighbors(grid, *position):
        neighbor_height = at(grid, *neighbor)
        position_height = at(grid, *position)

        if neighbor_height - position_height <= 1:
          pqueue.put((steps + 1, (neighbor, [*path, position])))

  # Handle getting stuck by steps > max size of grid
  return len(grid) * len(grid[0])

def part_1_solution(args):
  return dijkstra(args)

def part_2_solution(args):
  grid, initial, target = args

  initials = [initial]

  for y, row in enumerate(grid):
    for x, col in enumerate(row):
      if col == 0:
        initials.append((x, y))

  min_steps = len(grid) * len(grid[0])

  # This isn't optimized, but it's fast enough.
  for initial in initials:
    steps = dijkstra([grid, initial, target])
    min_steps = min(min_steps, steps)

  return min_steps

def transform_prompt():
  initial = None
  target  = None

  grid = []
  for y, row in enumerate(Prompt.read_to_list(__file__)):
    grid_row = []
    for x, col in enumerate(row):
      if col == 'S':
        initial = (x, y)
        # Min height is 'a', so one lower than that
        grid_row.append(H.index('a') - 1)
      elif col == 'E':
        target  = (x, y)
        # Max height is 'z', so one higher than that
        grid_row.append(H.index('z') + 1)
      else:
        grid_row.append(H.index(col))

    grid.append(grid_row)

  return [grid, initial, target]
