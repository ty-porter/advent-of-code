from src.prompt import Prompt

import itertools
from collections import namedtuple

Cube = namedtuple("Cube", ["x", "y", "z"])

def touching(c1, c2):
  return abs(c1.x - c2.x) + abs(c1.y - c2.y) + abs(c1.z - c2.z) == 1

def part_1_solution(cubes):
  surface = len(cubes) * 6

  for i, cube1 in enumerate(cubes):
    for j, cube2 in enumerate(cubes):
      if i == j: continue

      if touching(cube1, cube2):
        surface -= 1

  return surface

def part_2_solution(cubes):
  cubes = set(cubes)

  x = [x for x, _, _ in cubes]
  y = [y for _, y, _ in cubes]
  z = [z for _, _, z in cubes]

  max_x = max(x) + 1
  max_y = max(y) + 1
  max_z = max(z) + 1
  
  min_x = min(x) - 1
  min_y = min(y) - 1
  min_z = min(z) - 1

  internal_cubes = set()
  for x in range(min_x, max_x):
    for y in range(min_y, max_y):
      for z in range(min_z, max_z):
        if Cube(x, y, z) not in cubes:
          internal_cubes.add(Cube(x, y, z))

  to_check = [Cube(min_x, min_y, min_z)]

  outside_cubes = set()
  while to_check:
    c = to_check.pop()
    if c in cubes or c in outside_cubes:
      continue

    outside_cubes.add(c)
    if c in internal_cubes:
      internal_cubes.remove(c)

    if c.x - 1 >= min_x:
      to_check.append(Cube(c.x - 1, c.y, c.z))
    if c.x + 1 <= max_x:
      to_check.append(Cube(c.x + 1, c.y, c.z))
    if c.y - 1 >= min_y:
      to_check.append(Cube(c.x, c.y - 1, c.z))
    if c.y + 1 <= max_y:
      to_check.append(Cube(c.x, c.y + 1, c.z))
    if c.z - 1 >= min_z:
      to_check.append(Cube(c.x, c.y, c.z - 1))
    if c.z + 1 <= max_z:
      to_check.append(Cube(c.x, c.y, c.z + 1))

  surface = len(cubes) * 6
  for cube1, cube2 in itertools.combinations(cubes, 2):
    if touching(cube1, cube2):
      surface -= 2

  for cube in cubes:
    for internal in internal_cubes:
      if touching(cube, internal):
        surface -= 1

  return surface

def transform_prompt():
  return [Cube(*[int(value) for value in line.split(",")]) for line in Prompt.read_to_list(__file__)]