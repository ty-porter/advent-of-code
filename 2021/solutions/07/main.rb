require_relative "../../utils.rb"

class Array
  def median
    sorted = self.sort
    half_len = (sorted.length / 2.0).ceil
    (sorted[half_len-1] + sorted[-half_len]) / 2
  end
end

def part_1_solution(str)
  positions = str.split(",").map(&:to_i)
  median = positions.median

  value = positions.map { |position| (position - median).abs }.sum

  puts "PART 1: #{value}"
end

def part_2_solution(str)
  min = nil

  positions = str.split(",").map(&:to_i)
  
  positions.size.times do |i|
    sum = 0

    positions.each do |position|
      sum += (0..(position - i).abs).sum
    end

    min = sum if min.nil? || sum < min
  end

  puts "PART 2: #{min}"
end

test_str = "16,1,2,0,4,2,7,1,2,14"

part_1_solution str_single_from_prompt
part_2_solution str_single_from_prompt