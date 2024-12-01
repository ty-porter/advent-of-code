require_relative "solutions.rb"

small_test_grid_template = %w[
  11111
  19991
  19191
  19991
  11111
]

large_test_grid_template = %w[
  5483143223
  2745854711
  5264556173
  6141336146
  6357385478
  4167524645
  2176841721
  6882881134
  4846848554
  5283751526
]

small_test_grid = generate_octopi_grid(small_test_grid_template)
large_test_grid = generate_octopi_grid(large_test_grid_template)

def solutions(path)
  File.open(path).readlines.map(&:chomp).chunk_while do |cur, prv|
    cur != ""
  end.map do |group|
    group.reject { |str| str == "" }
  end
end

def generate_grid_from_file(path)
  solutions(path).map do |group|
    group.map do |row|
      row.chars.map(&:to_i)
    end
  end
end

single_step_solutions = generate_grid_from_file "steps_single.txt"
step_solutions        = generate_grid_from_file "steps_groups.txt"

def print_diff(start_grid_template, solutions, start: 0, step: 1)
  solutions.each_with_index do |sample_solution, index|
    starting_grid = start_grid_template.map(&:dup)
  
    output = part_1_solution(starting_grid, iterations: (index + start) * step)
  
    test_output = output.map.with_index do |row, row_index|
      solution_row = sample_solution[row_index]
  
      formatted_row = ""
  
      row.each_with_index do |octopus, i|
        solution_octopus = solution_row[i]
        color = solution_octopus == octopus ? Color::GREEN : Color::RED
  
        formatted_row += colorize(octopus.value, color)
        formatted_row += "," unless i == row.size - 1
      end
  
      [formatted_row, solution_row.join(",")].join("     ")
    end.join("\n")
  
    puts "STEP: #{(index + start) * step}"
    puts test_output
  end
end

print_diff(large_test_grid, single_step_solutions)
print_diff(large_test_grid, step_solutions, start: 1, step: 10)