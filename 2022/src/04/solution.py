from src.prompt import Prompt

import re

def part_1_solution(pairs):
  return sum(((s1 <= s2 and e1 >= e2) or (s1 >= s2 and e1 <= e2)) for s1, e1, s2, e2 in pairs)

def part_2_solution(pairs):
  return sum((max(s1, e1) >= min(s2, e2) and min(s1, e1) <= max(s2, e2)) for s1, e1, s2, e2 in pairs)

def transform_prompt():
  return [[int(id) for id in re.split("[,-]", line)] for line in Prompt.read_to_list(__file__)]
