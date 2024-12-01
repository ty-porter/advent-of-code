require_relative "../../utils.rb"

def expand_image(image, algorithm, iteration)
  field_value = iteration % 2 == 1 ? algorithm[0] : '.'
  vertical_expansion = field_value * (image.first.size + 2)
  horizontal_expansion = image.map { |row| [field_value, *row, field_value].join }

  [vertical_expansion, *horizontal_expansion, vertical_expansion]
end

def pixel(x, y, image, algorithm, iteration)
  bin = ''

  3.times do |y0|
    3.times do |x0|
      x1 = x - 1 + x0
      y1 = y - 1 + y0

      if x1 < 0 || y1 < 0 || y1 >= image.size || x1 >= image.first.size
        bin += algorithm[0] == '#' && iteration % 2 == 1 ? '1' : '0'
      else
        bin += image[y1][x1] == '#' ? '1' : '0'
      end
    end
  end

  algorithm[bin.to_i(2)]
end

def part_1_solution(groups, iterations: 2)
  algorithm = groups.first.join
  image = groups[1]

  iterations.times do |iteration|
    expanded_image = expand_image(image, algorithm, iteration)

    transformed_image = []
    expanded_image.each_with_index do |row, y|
      transformed_row = []

      row.chars.each_with_index do |col, x|
        transformed_row << pixel(x, y, expanded_image, algorithm, iteration)
      end

      transformed_image << transformed_row.join
    end

    image = transformed_image
  end

  pixel_count = image.join.count("#")

  puts "PART 1: #{pixel_count}" if iterations == 2

  pixel_count
end

def part_2_solution(str_groups_from_prompt)
  pixel_count = part_1_solution(str_groups_from_prompt, iterations: 50)

  puts "PART 2: #{pixel_count}"
end

part_1_solution str_groups_from_prompt
part_2_solution str_groups_from_prompt