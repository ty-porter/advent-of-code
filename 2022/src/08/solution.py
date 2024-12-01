from src.prompt import Prompt

def visible(grid):
  heights = []

  for y, row in enumerate(grid):
    new_row = []

    for x, height in enumerate(row):
      # Topmost, bottommost, leftmost or rightmost tree is always visible
      if x == 0 or x == len(row) - 1 or y == 0 or y == len(grid) - 1:
        new_row.append(1)
        continue

      # Slice the row for left/right
      left  = row[0:x]
      right = row[x + 1:]

      # Walk down column for top/bottom, then slice
      col    = [grid[transposed_y][x] for transposed_y in range(0, len(grid))]
      top    = col[0:y]
      bottom = col[y + 1:]

      x_min = min(max(left), max(right))
      y_min = min(max(top), max(bottom))

      new_row.append(1 if height > min(x_min, y_min) else 0)

    heights.append(new_row)

  return heights

def directional_score(value, direction):
  for dist, height in enumerate(direction):
    if value <= height:
      return dist + 1

  return len(direction)

def scene_score(value, top, bottom, left, right):
  score = 1

  for direction in [top, bottom, left, right]:
    score *= directional_score(value, direction)

  return score

def scene_scores(grid):
  heights = []

  for y, row in enumerate(grid):
    new_row = []

    for x, height in enumerate(row):
      # Slice the row for left/right
      left  = row[0:x] if x != 0 else [0]
      right = row[x + 1:] if x != len(row) - 1 else [0]

      # Walk down column for top/bottom, then slice
      col    = [grid[transposed_y][x] for transposed_y in range(0, len(grid))]
      top    = col[0:y] if y != 0 else [0]
      bottom = col[y + 1:] if y != len(col) - 1 else [0]

      new_row.append(
        scene_score(height,
          list(reversed(top)),
          bottom,
          list(reversed(left)),
          right
        )
      )

    heights.append(new_row)

  return heights

def part_1_solution(grid):
  visible_trees = visible(grid)

  return sum(sum(row) for row in visible_trees)

def part_2_solution(grid):
  tree_scores = scene_scores(grid)

  return max(max(row) for row in tree_scores)

def transform_prompt():
  return [[int(col) for col in row] for row in Prompt.read_to_list(__file__)]
