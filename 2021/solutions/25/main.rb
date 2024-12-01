require_relative "../../utils.rb"

def part_1_solution(grid)
  moved = true
  moves = 0

  while moved
    new_grid = []

    grid.each do |line|
      shifted = line.dup
      if shifted[-1] == '>' && shifted[0] == '.'
        shifted[0]  = 'x'
        shifted[-1] = 'y'
      end

      shifted.gsub!('>.', '.>')
      shifted.gsub!('x', '>')
      shifted.gsub!('y', '.')

      new_grid << shifted.chars
    end

    final_grid = []

    new_grid.transpose.each do |line|
      shifted = line.dup.join
      if shifted[-1] == 'v' && shifted[0] == '.'
        shifted[0]  = 'x'
        shifted[-1] = 'y'
      end

      shifted.gsub!('v.', '.v')
      shifted.gsub!('x', 'v')
      shifted.gsub!('y', '.')

      final_grid << shifted.chars
    end

    final_grid = final_grid.transpose.map(&:join)

    moved = grid != final_grid

    grid = final_grid
    moves += 1
  end

  puts "PART 1: #{moves}"
end

part_1_solution strs_from_prompt