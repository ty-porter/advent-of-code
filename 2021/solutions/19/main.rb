require_relative "../../utils.rb"

class Array
  def tally
    group_by { |v| v }.map { |k, v| [k, v.size] }.to_h
  end
end

class Scanner
  ROTATIONS = [
    -> (p) { [ p[0],  p[1],  p[2]] },
    -> (p) { [ p[1],  p[2],  p[0]] },
    -> (p) { [ p[2],  p[0],  p[1]] },
    -> (p) { [-p[0],  p[2],  p[1]] },
    -> (p) { [ p[2],  p[1], -p[0]] },
    -> (p) { [ p[1], -p[0],  p[2]] },
    -> (p) { [ p[0],  p[2], -p[1]] },
    -> (p) { [ p[2], -p[1],  p[0]] },
    -> (p) { [-p[1],  p[0],  p[2]] },
    -> (p) { [ p[0], -p[2],  p[1]] },
    -> (p) { [-p[2],  p[1],  p[0]] },
    -> (p) { [ p[1],  p[0], -p[2]] },
    -> (p) { [-p[0], -p[1],  p[2]] },
    -> (p) { [-p[1],  p[2], -p[0]] },
    -> (p) { [ p[2], -p[0], -p[1]] },
    -> (p) { [-p[0],  p[1], -p[2]] },
    -> (p) { [ p[1], -p[2], -p[0]] },
    -> (p) { [-p[2], -p[0],  p[1]] },
    -> (p) { [ p[0], -p[1], -p[2]] },
    -> (p) { [-p[1], -p[2],  p[0]] },
    -> (p) { [-p[2],  p[0], -p[1]] },
    -> (p) { [-p[0], -p[2], -p[1]] },
    -> (p) { [-p[2], -p[1], -p[0]] },
    -> (p) { [-p[1], -p[0], -p[2]] },
  ].freeze

  def initialize(number, points)
    @number = number
    @points = points
    @origin = [0, 0, 0] if number == 0
  end

  attr_accessor :number, :points, :origin

  def to_s
    "<Scanner ##{@number}: origin -> #{origin || 'UNKNOWN'}, size -> #{beacon_count} >"
  end

  def target_rotation(world)
    rotations.each do |rotation|
      translation, count = rotation.product(world.points).map { |p_rot, p_ref| relative_position(p_ref, p_rot) }.tally.max_by { |translation, count| count }

      @origin = translation

      return rotation.map { |p_rot| add_points(p_rot, translation) } if count >= 12
    end

    nil
  end

  def rotations
    @rotations ||= ROTATIONS.map do |rotation_function|
      points.map do |point|
        rotation_function.call(point)
      end
    end
  end

  def add_points(p1, p2)
    p1.zip(p2).map(&:sum)
  end

  def relative_position(p1, p2)
    p1.zip(p2).map { |pair| pair.reduce(:-) }
  end
end

def part_1_solution(groups)
  scanners = groups.map.with_index do |group, i| 
    point_list = group[1..-1].map { |point| point.split(',').map(&:to_i) }

    Scanner.new(i, point_list)
  end

  world = scanners.shift
  found_scanners = [world]

  until scanners.empty?
    target_scanner = scanners.detect do |target_scanner|
      absolute_points = target_scanner.target_rotation(world)
      next unless absolute_points

      world.points = [*world.points, *absolute_points].uniq
      
      true
    end

    break if target_scanner.nil?

    found_scanners << target_scanner
    scanners.select! { |scanner| scanner != target_scanner }
  end

  puts "PART 1: #{world.points.size}"

  found_scanners
end

def part_2_solution(scanners)
  distances = []

  scanners.each_with_index do |scanner1, i|
    scanners.each_with_index do |scanner2, j|
      next if i == j

      distances << scanner1.origin.zip(scanner2.origin).map { |pair| pair.reduce(:-).abs }.sum
    end
  end
 
  puts "PART 2: #{distances.max}"
end

scanners = part_1_solution str_groups_from_prompt
part_2_solution scanners