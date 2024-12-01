from src.prompt import Prompt

import re

def part_1_solution(values):
  stack, instructions = values

  for instruction in instructions:
    amt, source, dest = parse_instruction(instruction)

    for _ in range(amt):
      stack[dest].append(stack[source].pop())

  return "".join([stack[idx][-1] for idx in sorted(stack.keys())])

def part_2_solution(values):
  stack, instructions = values

  for instruction in instructions:
    amt, source, dest = parse_instruction(instruction)

    for move in stack[source][0 - amt:]:
      stack[source].pop()
      stack[dest].append(move)

  return "".join([stack[idx][-1] for idx in sorted(stack.keys())])

def parse_instruction(instruction):
  return [int(match) for match in re.findall("\d+", instruction)]

def build_stack(stack):
  stack_dict = {}

  for row in stack[:-1]:
    for stack_idx, offset in enumerate(range(0, len(row), 4)):
      letter = row[offset + 1:offset + 2]

      if letter == ' ':
        continue

      if stack_idx + 1 in stack_dict:
        stack_dict[stack_idx + 1].insert(0, letter)
      else:
        stack_dict[stack_idx + 1] = [letter]

  return stack_dict

def transform_prompt():
  stack = []
  stack_complete = False
  instructions = []
  
  for line in Prompt.read_to_list(__file__):
    if len(line) == 0:
      stack_complete = True
      continue

    if stack_complete:
      instructions.append(line)
    else:
      stack.append(line)

  return build_stack(stack), instructions