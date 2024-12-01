require_relative "../../utils.rb"

def part_1_solution(strs, iterations: 80, print: true)
  fish_list = strs.first.split(",").map(&:to_i)

  fish_counts = (0..8).map { |value| fish_list.count(value) || 0 }

  iterations.times do |day|
    expired_fish = fish_counts.shift

    fish_counts << expired_fish
    fish_counts[6] += expired_fish
  end

  puts "PART 1: #{fish_counts.sum}" if print

  fish_counts.sum
end

def part_2_solution(strs)
  puts "PART 2: #{part_1_solution(strs, iterations: 256, print: false)}"
end

test_strs = [
  "3,4,3,1,2"
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt