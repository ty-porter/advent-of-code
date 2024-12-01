require_relative "../../utils.rb"
require_relative "solutions.rb"

test_grid_template = %w[
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

test_grid     = generate_octopi_grid(test_grid_template)
solution_grid = generate_octopi_grid(strs_from_prompt)

part_1_solution solution_grid
part_2_solution solution_grid