from src.prompt import Prompt

def move(head, tail):
  distance = [head[0] - tail[0], head[1] - tail[1]]

  # Already touching
  if abs(distance[0]) <= 1 and abs(distance[1]) <= 1:
    return

  # Diagonal move
  if sum(abs(part) for part in distance) > 2:
    offset = [int(distance[0] / abs(distance[0])), int(distance[1] / abs(distance[1]))]
  # Cardinal move
  else:
    offset = [int(part / abs(part)) if abs(part) > 0 else 0 for part in distance]

  tail[0] += offset[0]
  tail[1] += offset[1]

def solution(instructions, rope_size=2):
  rope = [[0, 0] for _ in range(rope_size)]
  visited = []

  for direction, distance in instructions:
    for _ in range(distance):
      if direction == "U":
        rope[0][1] += 1
      elif direction == "D":
        rope[0][1] -= 1
      elif direction == "L":
        rope[0][0] -= 1
      elif direction == "R":
        rope[0][0] += 1
      else:
        raise Exception(f"{direction} is not a valid direction!")

      for i, section in enumerate(rope):
        if i == 0:
          continue

        prev_section = rope[i - 1]
        move(prev_section, section)

      if tuple(section) not in visited:
        visited.append(tuple(section))

  return len(visited)

def part_1_solution(instructions):
  return solution(instructions)

def part_2_solution(instructions):
  return solution(instructions, 10)

def transform_prompt():
  return [[part if i == 0 else int(part) for i, part in enumerate(line.split(" "))] for line in Prompt.read_to_list(__file__)]
