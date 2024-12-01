require_relative "../../utils.rb"
require 'set'

def intersect(cuboid1, cuboid2)
  result_cuboid = []

  3.times do |i|
    min = [cuboid1[i][0], cuboid2[i][0]].max
    max = [cuboid1[i][1], cuboid2[i][1]].min

    return if min > max

    result_cuboid << [min, max]
  end

  result_cuboid
end

def find_overlapping_cuboid_volume(instructions, clamp: true)
  instructions.map! do |instruction|
    operation, coordinate_list = instruction.split(' ')
    coordinate_list = coordinate_list.split(',').map do |coordinate|
      coords = coordinate.split('=').last.split('..').map(&:to_i)
      next coords unless clamp

      [[-50, coords.first].max, [50, coords.last].min]
    end

    next if coordinate_list.any? { |min, max|  min >= max}

    [operation == 'on', coordinate_list]
  end

  cuboids = []

  instructions.compact.each do |on, cuboid|
    cuboids.dup.each do |target_operation, target_cuboid|
      result_cuboid = intersect(cuboid, target_cuboid)

      cuboids << [!target_operation, result_cuboid] if result_cuboid
    end

    cuboids << [on, cuboid] if on
  end

  cuboids.map do |on, cuboid|
    mod = on ? 1 : -1

    cuboid.map { |min, max| max + 1 - min }.reduce(:*) * mod
  end.sum
end

def part_1_solution(instructions)
  volume = find_overlapping_cuboid_volume(instructions)

  puts "PART 1: #{volume}"
end

def part_2_solution(instructions)
  volume = find_overlapping_cuboid_volume(instructions, clamp: false)

  puts "PART 2: #{volume}"
end

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt