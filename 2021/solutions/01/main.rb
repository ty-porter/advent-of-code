require_relative "../../utils.rb"

def part_1_solution(nums)
  counter = 0
  
  nums.each_with_index do |num, i|
    next if i == 0
  
    counter += 1 if num > nums[i - 1]
  end
  
  puts "PART 1: #{counter}"
end

def part_2_solution(nums)
  counter = 0
  window_size = 3


  (1..nums.size - window_size).each do |start|
    stop = start + window_size - 1

    old_window = nums[start - 1..stop - 1]
    new_window = nums[start..stop]

    counter += 1 if old_window.sum < new_window.sum
  end

  puts "PART 2: #{counter}"
end

test_nums = [
  199,
  200,
  208,
  210,
  200,
  207,
  240,
  269,
  260,
  263
]

part_1_solution nums_from_prompt
part_2_solution nums_from_prompt