from src.prompt import Prompt

SCORE_TABLE = { 'A X': 4, 'A Y': 8, 'A Z': 3, 'B Y': 5, 'B Z': 9, 'B X': 1, 'C Z': 6, 'C X': 7, 'C Y': 2 }
MAPPING = { 'A X': 'A Z', 'A Y': 'A X', 'A Z': 'A Y', 'B Y': 'B Y', 'B Z': 'B Z', 'B X': 'B X', 'C Z': 'C X', 'C X': 'C Y', 'C Y': 'C Z'}

def part_1_solution(values):
  return sum(SCORE_TABLE[value] for value in values)

def part_2_solution(values):
  return sum(SCORE_TABLE[MAPPING[value]] for value in values)

def transform_prompt():
  return Prompt.read_to_list(__file__)
