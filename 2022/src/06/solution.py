from src.prompt import Prompt

def solution(values, size):
  marker = ""

  for idx, received in enumerate(values):
    if len(marker) < size:
      marker += received
      continue

    marker = marker[1:] + received

    if len(set(marker)) == size:
      return idx + 1

def part_1_solution(values):
  return solution(values, 4)

def part_2_solution(values):
  return solution(values, 14)

def transform_prompt():
  return Prompt.read(__file__)
