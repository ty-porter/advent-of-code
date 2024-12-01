from src.prompt import Prompt

class CPU:

  def __init__(self):
    self.pc = 0
    self.x  = 1
    self.trace = { self.pc: self.x }

  def parse_instructions(self, instructions):
    for instruction in instructions:
      if instruction == "noop":
        self.noop()
      else:
        _addx, amt = instruction.split(" ")
        self.addx(int(amt))

  def increment_program_counter(before):
    def inc_pc_counter_decorator(fn, *args):
      def decorator(self, *fnargs):
        for _ in range(before):
          self.pc += 1
          self.trace[self.pc] = self.x

        fn(self, *fnargs)
          
      return decorator
    return inc_pc_counter_decorator

  def parse_instruction(self):
    pass
    
  @increment_program_counter(1)
  def noop(self):
    pass

  @increment_program_counter(2)
  def addx(self, amt):
    self.x += amt

def part_1_solution(instructions):
  cpu = CPU()
  cpu.parse_instructions(instructions)

  return sum(cpu.trace[target] * target for target in range(20, 221, 40))

def part_2_solution(instructions):
  cpu = CPU()
  cpu.parse_instructions(instructions)

  crt = []

  for row in range(6):
    crt_row = ""

    for col in range(40):
      sprite_position = (col + 1) + (row * 40)
      dist = abs(col - cpu.trace[sprite_position]) <= 1
      crt_row += "#" if dist else "."

    crt.append(crt_row)

  indent = " " * 14
  return f"\n{indent}".join(crt)

def transform_prompt():
  return Prompt.read_to_list(__file__)
