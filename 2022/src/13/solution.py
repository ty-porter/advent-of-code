from src.prompt import Prompt

import functools

LESS    = -1
EQUAL   = 0
GREATER = 1

DIVIDERS = [2, 6]

def compare(x, y, indent = 0):
  if isinstance(x, list) and isinstance(y, list):
    for i in range(min(len(x), len(y))):
      comparison = compare(x[i], y[i], indent + 1)

      if comparison is not EQUAL:
        return comparison

    if x == y:
      return EQUAL

    return LESS if len(x) < len(y) else GREATER
  elif isinstance(x, int) and isinstance(y, int):
    if x == y:
      return EQUAL
    else:
      return LESS if x < y else GREATER
  else:
    next_a = [x] if isinstance(x, int) else x
    next_b = [y] if isinstance(y, int) else y

    return compare(next_a, next_b, indent + 1)

def part_1_solution(pairs):
  count  = 0
  for i, pair in enumerate(pairs):
    if compare(*pair) == LESS:
      count += (i + 1)

  return count

def part_2_solution(pairs):
  ordered_packets = sorted([item for pair in pairs for item in pair], key=functools.cmp_to_key(compare))

  # Not really sure what the slowdown was caused by, but it's simple to iterate over the ordered packets and determine where the dividers SHOULD be
  divider_pairs = []
  for divider in DIVIDERS:
    max_pair = None
    for i, pair in enumerate(ordered_packets):
      if isinstance(pair, list) and len(pair) > 0:
        item = pair[0]

        while isinstance(item, list) and len(item) > 0:
          item = item[0]

        if not isinstance(item, list):
          if item < divider:
            max_pair = i

    divider_pairs.append(max_pair)

  return (divider_pairs[0] + 2) * (divider_pairs[1] + 3)

def transform_prompt():
  return [[eval(packet) for packet in pair.split("\n")] for pair in Prompt.read(__file__).split("\n\n")]
