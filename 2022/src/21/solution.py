from src.prompt import Prompt

import copy

class Monkey:

  def __init__(self, name, expression):
    self.name = name
    self.expression = expression

  def evaluate(self, monkeys):
    if isinstance(self.expression, int):
      return self.expression
    else:
      name1, operator, name2 = self.expression.split(" ")
      monkey1 = monkeys[name1]
      monkey2 = monkeys[name2]

      result = eval(f"{monkey1.evaluate(monkeys)} {operator} {monkey2.evaluate(monkeys)}")

      if isinstance(result, float):
        return int(result)
      else:
        return result

def part_1_solution(monkeys):
  return monkeys["root"].evaluate(monkeys)

def part_2_solution(monkeys):
  copied_monkeys = copy.deepcopy(monkeys)
  root = copied_monkeys["root"]
  humn = copied_monkeys["humn"]
  name1, _, name2 = root.expression.split(" ")

  root.expression = f"{name1} == {name2}"

  target1 = copied_monkeys[name1]
  target2 = copied_monkeys[name2]

  high = int(1e20)
  low = 1

  midpoint = high // 2
  humn.expression = midpoint
  current_value = target1.evaluate(copied_monkeys) - target2.evaluate(copied_monkeys)

  found = False

  while not found:
    humn.expression = high
    high_value = target1.evaluate(copied_monkeys) - target2.evaluate(copied_monkeys)

    humn.expression = low
    low_value = target1.evaluate(copied_monkeys) - target2.evaluate(copied_monkeys)

    if abs(current_value) - abs(high_value) > abs(current_value) - abs(low_value):
      low = midpoint
    else:
      high = midpoint

    midpoint = (high + low) // 2

    humn.expression = midpoint
    current_value = target1.evaluate(copied_monkeys) - target2.evaluate(copied_monkeys)

    if current_value == 0:
      return midpoint

def transform_prompt():
  monkeys = {}

  for line in Prompt.read_to_list(__file__):
    name, expression = line.split(": ")

    if " " not in expression:
      expression = int(expression)

    monkey = Monkey(name, expression)
    monkeys[name] = monkey

  return monkeys
