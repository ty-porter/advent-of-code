from src.prompt import Prompt

import copy
from collections import namedtuple

Number = namedtuple("Number", ["value", "origin"])

KEY = 811589153

def mix(values, order=None):
  numbers = [value for value in values]
  if order is None:
    order = copy.deepcopy(values)

  for value in order:
    number     = value.value
    index      = numbers.index(value)
    offset     = abs(number) % (len(values) - 1)
    offset     = -offset if number < 0 else offset
    next_index = index + offset

    if next_index >= len(numbers):
      next_index = next_index % (len(numbers)) + 1
    elif next_index == 0:
      next_index = 0 if offset > 0 else len(numbers)

    numbers.pop(index)
    numbers.insert(next_index, value)

  return numbers

def part_1_solution(values):
  numbers = mix(values)
  zero_index = [number.value for number in numbers].index(0)

  coords = []

  for i in range(1, 4):
    abs_index = (1000 * i) + zero_index
    modulo = len(numbers)
    coords.append(numbers[abs_index % modulo].value)

  return sum(coords)

def part_2_solution(values):
  numbers = [Number(n.value * KEY, n.origin) for n in values]
  order = copy.deepcopy(numbers)

  for _ in range(10):
    numbers = mix(numbers, order=order)

  zero_index = [number.value for number in numbers].index(0)

  coords = []

  for i in range(1, 4):
    abs_index = (1000 * i) + zero_index
    modulo = len(numbers)
    coords.append(numbers[abs_index % modulo].value)

  return sum(coords)

def transform_prompt():
  # Tuple, all values are unique, in case one matches value, index will differ
  return [Number(int(value), i) for i, value in enumerate(Prompt.read_to_list(__file__))]
