require_relative "../../utils.rb"

def part_1_solution(values, limit: 1)
  points, folds = values

  points.map! do |point|
    point.split(",").map(&:to_i)
  end

  x_size = points.max_by(&:first).first + 1
  y_size = points.max_by(&:last).last + 1

  folds.map! do |fold|
    fold_params = fold.split.last.split("=")

    { fold_params.first.to_sym => fold_params.last.to_i }
  end

  grid = Array.new(y_size) { Array.new(x_size) { "." } }

  points.each do |point|
    x, y = point

    grid[y][x] = "#"
  end

  folds.each_with_index do |fold, index|
    if fold.has_key?(:x)
      grid = grid.transpose
    end

    slice_size = fold.values.first

    top = grid.take(slice_size)
    bottom = grid.reverse.take(slice_size)

    grid = top.zip(bottom).map do |row_pair|
      new_row = row_pair.first.zip(row_pair.last)

      new_row.map do |cell_pair|
        cell_pair.any?("#") ? "#" : "."
      end
    end

    if fold.has_key?(:x)
      grid = grid.transpose
    end

    break if limit && index + 1 == limit
  end

  value = grid.flatten.count("#")

  if limit.nil?
    puts "PART 2:"
    grid.p2d(delimiter: "")
  else
    puts "PART 1: #{value}"
  end
end

def part_2_solution(values)
  part_1_solution(values, limit: nil)
end

test_grid = %w[
  6,10
  0,14
  9,10
  0,3
  10,4
  4,11
  6,0
  6,12
  4,1
  0,13
  10,12
  3,4
  3,0
  8,4
  1,10
  2,14
  8,10
  9,0
]

test_folds = [
  'fold along y=7',
  'fold along x=5'
]

test_strs = [test_grid, test_folds]

part_1_solution str_groups_from_prompt
part_2_solution str_groups_from_prompt