class Array
  # Usage:
  #   print grid
  def to_s
    max_size = flatten.map { |octopus| octopus.value.digits.size }.max

    map do |row|
      row.map { |octopus| octopus.value.to_s.rjust(max_size) }.join(",")
    end.join("\n") + "\n"
  end
end

class Octopus
  include Comparable

  def initialize(value)
    @value = value
    @flashed = false
  end

  attr_accessor :flashed, :value

  def <=>(other)
    @value <=> other
  end

  def flash!
    @flashed = true
  end

  def to_s
    @value.to_s
  end
end

def propagate_flash!(grid, x, y)
  adjacent_positions = [
    [x - 1, y - 1],
    [x    , y - 1],
    [x + 1, y - 1],

    [x - 1, y    ],
    [x + 1, y    ],

    [x - 1, y + 1],
    [x    , y + 1],
    [x + 1, y + 1],
  ]
  
  adjacent_positions.each do |position|
    guarded_increment_grid_value!(grid, *position)
  end
end

def guarded_increment_grid_value!(grid, x, y)
  return if x < 0 || y < 0

  begin
    grid[y][x].value += 1
  rescue StandardError => exception
  end
end

def reset_flash_timers(grid)
  grid.map! do |row|
    row.map do |octopus|
      next Octopus.new(0) if octopus.flashed

      octopus
    end
  end
end

def part_1_solution(grid, iterations: 100)
  flash_count = 0

  iterations.times do |i|

    grid.map! do |row|
      row.map do |octopus|
        new_octopus = Octopus.new(octopus.value + 1)
        new_octopus.flashed = octopus.flashed

        new_octopus
      end
    end

    loop do
      flashes = []
  
      grid.each_with_index do |row, y|
        row.each_with_index do |octopus, x|
          if octopus > 9 && !octopus.flashed
            flashes << [x, y]
            octopus.flash!

            flash_count += 1
          end
        end
      end
  
      break if flashes.empty?

      flashes.each do |flash|
        propagate_flash!(grid, *flash)
      end
    end

    return i + 1 if grid.flatten.all?(&:flashed)

    reset_flash_timers(grid)
  end

  puts "PART 1: #{flash_count}"

  grid
end

def part_2_solution(grid)
  step = part_1_solution(grid, iterations: 1_000_000)

  puts "PART 2: #{step}"
end

def generate_octopi_grid(array)
  array.map { |str| str.chars.map { |value| Octopus.new(value.to_i) } }
end