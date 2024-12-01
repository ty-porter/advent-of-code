require_relative "../../utils.rb"

class ALU
  def initialize(input, instructions, output_registers: false)
    @input = input.digits.reverse
    @instructions = parse_instructions(instructions)
    @registers = %i[w x y z].zip([0, 0, 0, 0]).to_h
    @output_registers = output_registers
  end

  attr_reader :input, :instructions, :registers

  def run!
    @instructions.each do |instruction, args|
      result = send(instruction, *args)

      puts "#{registers.map { |k, v| "#{k}: #{v}" }.join(', ')}" if @output_registers
    end
  end
  
  private
  
  def parse_instructions(instructions)
    instructions.map do |instruction|
      opcode, *args = instruction.split(' ')

      [opcode.to_sym, args.map { |arg| arg.match?(/[wxyz]/) ? arg.to_sym : arg.to_i }]
    end.compact
  end

  # inp a   - Read an input value and write it to variable a.
  # add a b - Add the value of a to the value of b, then store the result in variable a.
  # mul a b - Multiply the value of a by the value of b, then store the result in variable a.
  # div a b - Divide the value of a by the value of b, truncate the result to an integer, then store the result in variable a. (Here, "truncate" means to round the value toward zero.)
  # mod a b - Divide the value of a by the value of b, then store the remainder in variable a. (This is also called the modulo operation.)
  # eql a b - If the value of a and b are equal, then store the value 1 in variable a. Otherwise, store the value 0 in variable a.

  def inp a
    @registers[a] = @input.shift
  end

  def add a, b
    b = @registers[b] if b.is_a?(Symbol)
    @registers[a] += b
  end

  def mul a, b
    b = @registers[b] if b.is_a?(Symbol)
    @registers[a] *= b
  end

  def div a, b
    b = @registers[b] if b.is_a?(Symbol)
    @registers[a] /= b
  end

  def mod a, b
    b = @registers[b] if b.is_a?(Symbol)
    @registers[a] = @registers[a] % b
  end

  def eql a, b
    b = @registers[b] if b.is_a?(Symbol)
    @registers[a] = @registers[a] == b ? 1 : 0
  end
end

def part_1_solution(instructions)
  target = 97919997299495
  alu = ALU.new(target, instructions)
  alu.run!

  raise "INVALID" unless alu.registers[:z] == 0

  puts "PART 1: #{target}"
end

def part_2_solution(instructions)
  target = 51619131181131
  alu = ALU.new(target, instructions)
  alu.run!

  raise "INVALID" unless alu.registers[:z] == 0

  puts "PART 2: #{target}"
end

# No code solution, verified here using ALU emulation
part_1_solution strs_from_prompt
part_2_solution strs_from_prompt