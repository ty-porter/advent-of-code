from src.prompt import Prompt

import functools

class Monkeys:
  def __init__(self, monkeys):
    self.monkeys = {}
    self.divisor = 1

    for monkey in monkeys:
      self.monkeys[monkey.id] = monkey

  def fetch(self, id):
    return self.monkeys[id]

  def toss(self, start, dest):
    tossed = self.fetch(start).toss()
    self.fetch(dest).receive(tossed)

  def perform_iterations(self, amt):
    for i in range(amt):
      self.perform_iteration()

  def perform_iteration(self):
    for key in self.monkeys.keys():
      monkey = self.monkeys[key]

      for _ in range(len(monkey.items)):
        receiver = monkey.perform_inspection(self.divisor)
        self.toss(monkey.id, receiver)

  def monkey_business(self):
    scores = [self.monkeys[monkey].inspection_count for monkey in self.monkeys]

    return functools.reduce(lambda x, y: x * y, sorted(scores)[-2:])

  def set_divisor(self, value=None):
    if value is not None:
      self.divisor = value
    else:
      for monkey in self.monkeys.values():
        self.divisor *= monkey.condition

class Monkey:
  def __init__(self, id, items, operation, condition, true_result, false_result):
    self.id = int(id.split(" ")[-1][0])
    self.items = [int(item) for item in items.split(": ")[-1].split(", ")]
    self.operation = operation.split("= ")[-1]
    self.condition = int(condition.split("divisible by ")[-1])
    self.true_result = int(true_result.split("monkey ")[-1])
    self.false_result = int(false_result.split("monkey ")[-1])

    self.inspection_count = 0

  def perform_inspection(self, divisor):
    self.inspection_count += 1

    item = self.items[0]
    item = eval(self.operation.replace("old", str(item)))

    if divisor == 3:
      item = item // divisor
    else:
      item %= divisor

    self.items[0] = item

    if item % self.condition == 0:
      return self.true_result
    else:
      return self.false_result

  def toss(self):
    return self.items.pop(0)

  def receive(self, value):
    self.items.append(value)

  def __str__(self):
    return (f'<[Monkey {self.id}]: (Items: {self.items}, '
            f'Operation: {self.operation}, '
            f'Condition: {self.condition}, '
            f'true_result: {self.true_result}, '
            f'false_result: {self.false_result}, '
            f'InspectionCount: {self.inspection_count}>')

def part_1_solution(monkeys):
  monkeys.set_divisor(3)
  monkeys.perform_iterations(20)
  
  return monkeys.monkey_business()

def part_2_solution(monkeys):
  monkeys.set_divisor()
  monkeys.perform_iterations(10_000)
  
  return monkeys.monkey_business()

def transform_prompt():
  return Monkeys([Monkey(*monkey.split("\n")) for monkey in Prompt.read(__file__).split("\n\n")])
