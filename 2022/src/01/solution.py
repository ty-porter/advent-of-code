from src.prompt import Prompt

def part_1_solution(values):
  count = 0
  maximum = 0

  for value in values:
    if value != "":
      count += int(value)
    else:
      count = 0

    if maximum < count:
      maximum = count

  return maximum

def part_2_solution(values):
  count = 0
  counts = []

  for value in values:
    if value != "":
      count += int(value)
    else:
      count = 0

    counts.append(count)

    if len(counts) > 3:
      counts.remove(min(counts))

  return sum(counts)

def transform_prompt():
  return Prompt.read_to_list(__file__)
