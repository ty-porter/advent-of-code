from src.prompt import Prompt

START_X = 500
START_Y = 0

WALL = 1
SAND = 2

def dist(p1, p2):
  return (p1[0] - p2[0], p1[1] - p2[1])

def points_between(p1, p2):
  distance = dist(p1, p2)

  if distance[0] != 0:
    direction = -1 if distance[0] > 0 else 1
    return [(p1[0] - distance[0] - (i * direction), p1[1]) for i in range(abs(distance[0]) + 1)]
  else:
    direction = -1 if distance[1] > 0 else 1
    return [(p1[0], p1[1] - distance[1] - (i * direction)) for i in range(abs(distance[1]) + 1)]

def falling_sand(lines, floor_offset=0):
  cave = {}
  floor = None
  solid_floor = floor_offset != 0

  for line in lines:
    prv_point = line[0]
    cave[prv_point] = WALL
    
    for point in line[1:]:
      for new_point in points_between(prv_point, point):
        if floor is None or floor < new_point[1]:
          floor = new_point[1]

        cave[new_point] = WALL

      prv_point = point
  
  floor += floor_offset

  grid_full = False
  while not grid_full:
    stopped = False
    grain = [START_X, START_Y]
    while not stopped:
      downward_move = tuple([grain[0], grain[1] + 1])
      left_diagonal_move = tuple([grain[0] - 1, grain[1] + 1])
      right_diagonal_move = tuple([grain[0] + 1, grain[1] + 1])

      # Always make sure there's a floor under candidate moves if solid floor
      if solid_floor:
        cave[(downward_move[0], floor)]       = WALL
        cave[(left_diagonal_move[0], floor)]  = WALL
        cave[(right_diagonal_move[0], floor)] = WALL

      if not solid_floor and downward_move[1] > floor:
        grid_full = True

        break

      if not solid_floor or (solid_floor and downward_move[1] <= floor):
        if downward_move not in cave:
          grain = list(downward_move)
        elif left_diagonal_move not in cave:
          grain = list(left_diagonal_move)
        elif right_diagonal_move not in cave:
          grain = list(right_diagonal_move)
        else:
          cave[tuple(grain)] = SAND
          stopped = True

        if grain == [START_X, START_Y]:
          grid_full = True
          
          break
      else:
        cave[tuple(grain)] = SAND
        stopped = True

        if grain == [START_X, START_Y]:
          grid_full = True
          
          break

  return list(cave.values()).count(SAND)

def part_1_solution(lines):
  return falling_sand(lines)

def part_2_solution(lines):
  return falling_sand(lines, 2)

def transform_prompt():
  return [[(int(part.split(",")[0]), int(part.split(",")[1])) for part in line.split(" -> ")] for line in Prompt.read_to_list(__file__)]
