require_relative "../../utils.rb"

class Grid
  def initialize(lines, test: false)
    @lines = lines
    @endpoints = lines.map { |line| [line.start, line.stop] }.flatten
    @size = [@endpoints.max_by(&:x).x + 1, @endpoints.max_by(&:y).y + 1]
   
    if !test
      @grid = Array.new(size.last) do
        Array.new(size.first) { 0 }
      end
    else
      # Test grid size of 10
      @grid = Array.new(10) do
        Array.new(10) { 0 }
      end
    end

    @diagonal = false
  end

  attr_reader :lines, :grid, :size
  attr_accessor :diagonal

  def to_s
    grid.map do |row|
      row.map { |col| col == 0 ? "." : col }.join
    end.join("\n")
  end

  def count_greater_than(target)
    grid.flatten.count { |value| value > target}
  end

  def update!
    lines.each do |line|
      line.points_between(diagonal: diagonal).each do |point|
        grid[point.y][point.x] += 1
      end
    end
  end
end

class Line
  def initialize(start, stop)
    @start = start
    @stop = stop
  end

  attr_reader :start, :stop

  def points_between(diagonal:)
    x_min, x_max = [start.x, stop.x].minmax
    y_min, y_max = [start.y, stop.y].minmax

    if x_min == x_max
      (y_min..y_max).map do |y_offset|
        Point.from_ints(x_min, y_offset)
      end
    elsif y_min == y_max
      (x_min..x_max).map do |x_offset|
        Point.from_ints(x_offset, y_max)
      end
    elsif (x_min - x_max).abs == (y_min - y_max).abs && x_max > x_min && diagonal
      (x_max - x_min + 1).times.map do |i|
        x_offset = stop.x > start.x ? i : (i * -1)
        y_offset = stop.y > start.y ? i : (i * -1)

        Point.from_ints(start.x + x_offset, start.y + y_offset)
      end
    else
      []
    end
  end

  def to_s
    [start, stop].map do |type|
      [type.x, type.y].join(",")
    end.join(" -> ")
  end
end

class Point
  def initialize(str)
    @x = str.split(",").first.to_i
    @y = str.split(",").last.to_i
  end

  attr_reader :x, :y

  class << self
    def from_string(str)
      Point.new(str)
    end

    def from_ints(x, y)
      Point.new("#{x},#{y}")
    end
  end
end

def generate_grid(strs, test: false)
  lines = strs.map do |str|
    Line.new(*str.split(" -> ").map { |str_point| Point.from_string(str_point) })
  end

  Grid.new(lines, test: test)
end

def part_1_solution(strs, test: false)
  grid = generate_grid(strs, test: test)

  grid.update!

  puts "PART 1: #{grid.count_greater_than(1)}"
end

def part_2_solution(strs, test: false)
  grid = generate_grid(strs, test: test)
  grid.diagonal = true

  grid.update!

  puts "PART 2: #{grid.count_greater_than(1)}"
end

test_strs = [
  '0,9 -> 5,9',
  '8,0 -> 0,8',
  '9,4 -> 3,4',
  '2,2 -> 2,1',
  '7,0 -> 7,4',
  '6,4 -> 2,0',
  '0,9 -> 2,9',
  '3,4 -> 1,4',
  '0,0 -> 8,8',
  '5,5 -> 8,2'
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt