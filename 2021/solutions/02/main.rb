require_relative "../../utils.rb"

def part_1_solution(strs)
  pos = [0, 0]

  strs.each do |str|
    command, amount = str.split(" ")

    index = command == "forward" ? 0 : 1
    amount = command == "up" ? amount.to_i * -1 : amount.to_i

    pos[index] += amount
  end

  puts "PART 1: #{pos.reduce(:*)}"
end

def part_2_solution(strs)
  pos = [0, 0, 0]

  strs.each do |str|
    command, amount = str.split(" ")

    index = command == "forward" ? 0 : 2
    amount = command == "up" ? amount.to_i * -1 : amount.to_i

    if index == 2
      pos[index] += amount
    else
      h_pos, depth, aim = pos

      pos[0] += amount
      pos[1] += amount * aim
    end
  end

  puts "PART 2: #{pos.take(2).reduce(:*)}"
end

test_strs = [
  'forward 5',
  'down 5',
  'forward 8',
  'up 3',
  'down 8',
  'forward 2'
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt