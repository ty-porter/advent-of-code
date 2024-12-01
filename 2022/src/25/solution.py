from src.prompt import Prompt

class SNAFU:

  DIGITS = { -2: "=", -1: "-", 0: "0", 1: "1", 2: "2" }

  def __init__(self, snafu=None, decimal=None):
    self.snafu = snafu
    self.decimal = decimal

    self.update_snafu()
    self.update_decimal()

  def update_snafu(self):
    if self.snafu is not None: return

    digits = self.decimal
    snafu = ""

    while digits != 0:
      snafu += SNAFU.DIGITS[(digits + 2) % 5 - 2]
      digits = (digits - ((digits + 2) % 5 - 2)) // 5

    self.snafu = snafu[::-1]

  def update_decimal(self):
    total = 0

    if self.decimal is not None: return

    for i, character in enumerate(reversed(self.snafu)):
      if character in ["-", "="]:
        value = -(["-", "="].index(character) + 1)
      else:
        value = int(character)

      total += (5 ** i) * value
    
    self.decimal = total

    return total

  def __add__(self, other):
    return SNAFU(decimal=self.decimal + other.decimal)

  def __str__(self):
    return f"{self.snafu}"

def part_1_solution(values):
  return sum(values, SNAFU("0"))

def part_2_solution(_):
  return

def transform_prompt():
  return [SNAFU(line) for line in Prompt.read_to_list(__file__)]
