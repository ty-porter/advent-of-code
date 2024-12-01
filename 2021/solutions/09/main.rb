require_relative "../../utils.rb"

class Array
  def neighbors(x, y)
    values = []

    values << self[y    ][x + 1] if x < self[y].size - 1
    values << self[y    ][x - 1] if x > 0
    values << self[y + 1][x    ] if y < self.size - 1
    values << self[y - 1][x    ] if y > 0

    values
  end
end

def part_1_solution(strs)
  heightmap = strs.map { |str| str.chars.map(&:to_i) }

  risks = []

  heightmap.each_with_index do |row, y|
    row.each_with_index do |value, x|
      risks << value + 1 if heightmap.neighbors(x, y).all? { |neighbor| neighbor > value }
    end
  end

  puts "PART 1: #{risks.sum}"
end

def basin_size(heightmap, x, y, checked = [])
  positions = []

  if !checked.include?([x, y])
    positions << [x + 1, y    ] if x < heightmap[y].size - 1
    positions << [x - 1, y    ] if x > 0
    positions << [x    , y + 1] if y < heightmap.size - 1
    positions << [x    , y - 1] if y > 0 

    checked << [x, y]

    positions.reject! { |position| heightmap[position.last][position.first] == 9 }
  end

  return checked.uniq.size if positions == []

  positions.map { |position| basin_size(heightmap, *position, checked) }.flatten.max
end

def part_2_solution(strs)
  heightmap = strs.map { |str| str.chars.map(&:to_i) }

  basins = []

  heightmap.each_with_index do |row, y|
    row.each_with_index do |value, x|
      basins << basin_size(heightmap, x, y) if heightmap.neighbors(x, y).all? { |neighbor| neighbor > value }
    end
  end
  
  product = basins.sort.reverse.take(3).reduce(:*)

  puts "PART 2: #{product}"
end

test_strs = %w[
  2199943210
  3987894921
  9856789892
  8767896789
  9899965678
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt