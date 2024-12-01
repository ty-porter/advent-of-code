require_relative "../../utils.rb"

def part_1_solution(strs)
  gamma = strs.map { |strs| strs.chars.map(&:to_i) }.transpose.map { |bits| bits.sum > bits.size - bits.sum ? 1 : 0 }
  epsilon = gamma.map { |bit| bit == 1 ? 0 : 1 }

  value = [gamma, epsilon].map { |value| value.join("").to_i(2) }.reduce(:*)

  puts "PART 1: #{value}"
end

def find_from_candidates(strs, symbol)
  index = -1

  while strs.size > 1 do
    index += 1

    transposed = strs.map { |strs| strs.chars.map(&:to_i) }.transpose
    target = transposed.map { |bits| bits.sum.send(symbol, bits.size - bits.sum) ? 1 : 0 }[index]

    strs = strs.select { |str| str[index] == target.to_s }
  end

  strs.first
end

def part_2_solution(strs)
  o2_candidates  = strs.dup
  co2_candidates = strs.dup

  o2  = find_from_candidates(o2_candidates, :>=)
  co2 = find_from_candidates(co2_candidates, :<)

  value = [o2, co2].map { |value| value.to_i(2) }.reduce(:*)

  puts "PART 2: #{value}"
end

test_strs = %w[
  00100
  11110
  10110
  10111
  10101
  01111
  00111
  11100
  10000
  11001
  00010
  01010
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt