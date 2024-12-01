from src.prompt import Prompt

import functools, string

PRIORITY = "_" + string.ascii_lowercase + string.ascii_uppercase

def part_1_solution(values):
  count = 0

  for ruck in values:
    ruck_size = int(len(ruck) / 2)

    compartment1 = ruck[0:ruck_size]
    compartment2 = ruck[ruck_size:]

    intersection = set(compartment1).intersection(compartment2).pop()

    count += PRIORITY.index(intersection)

  return count

def part_2_solution(values):
  count = 0

  for ruck_idx_start in range(0, len(values), 3):
    rucks = []

    for ruck_idx in range(0, 3):
      rucks.append(set(values[ruck_idx_start + ruck_idx]))

    intersection = functools.reduce(lambda ruck1, ruck2: ruck1.intersection(ruck2), rucks).pop()

    count += PRIORITY.index(intersection)

  return count

def transform_prompt():
  return Prompt.read_to_list(__file__)
