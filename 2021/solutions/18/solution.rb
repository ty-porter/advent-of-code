require_relative '../../utils.rb'

def add(fish1, fish2)
  fish = "[#{fish1},#{fish2}]"

  reduce(fish)
end

def reduce(fish, iter_limit = nil, iterations = 0)
  # Guard clause lets test runner test single step
  return fish if iter_limit == iterations

  i = 0
  nest = 0

  # Explode
  while i < fish.size
    nest += 1 if fish[i] == '['
    nest -= 1 if fish[i] == ']'

    if nest > 4
      return reduce(explode(fish, i), iter_limit, iterations + 1)
    end

    i += 1
  end

  # Split
  if fish.match?(/\d{2}/)
    return reduce(split(fish, fish.index(/\d{2}/)), iter_limit, iterations + 1)
  end

  fish
end

def explode(fish, i)
  match = while i < fish.size
    subset = fish[i, 7]
    match = subset.match(/\[\d+,\d+\]/)

    break match[0] if match

    i += 1
  end

  l_value, r_value = eval(match)

  l_half = fish[0, i]
  r_half = fish[i + match.size..-1]

  left_substring, right_substring = generate_exploded_substrings(l_value, r_value, l_half, r_half)

  [left_substring, 0, right_substring].join
end

def split(fish, i)
  value = fish[i, 2].to_i

  fish[0, i] + "[#{value / 2},#{(value / 2.0).ceil}]" + fish[i + 2..-1]
end

def generate_exploded_substrings(l_value, r_value, left, right)
  l_num_index = left.rindex(/\d/)

  if l_num_index.nil?
    l_substring = left
  else
    trim_size = left[l_num_index - 1, 2].to_i.digits.size
    l_num = left[l_num_index - trim_size + 1, 2]
    l_sum = l_num.to_i + l_value
    l_substring = [left[0, l_num_index - trim_size + 1], l_sum, left[l_num_index + 1..-1]].join
  end

  r_num_index = right.index(/\d/)

  if r_num_index.nil?
    r_substring = right
  else
    trim_size = right[r_num_index, 2].to_i.digits.size
    r_num = right[r_num_index, 2]
    r_sum = r_num.to_i + r_value
    r_substring = [right[0, r_num_index], r_sum, right[r_num_index + trim_size..-1]].join
  end

  [l_substring, r_substring]
end

def magnitude(value)
  return value if value.is_a?(Integer)

  value.map.with_index do |object, i|
    if i == 0
      3 * magnitude(object)
    else
      2 * magnitude(object)
    end
  end.sum
end

def part_1_solution(values, printable: true, return_sum: false)
  sum = values.first

  values.each { |value| sum = add(sum, value) }

  return sum if return_sum

  array = eval(sum)
  mag = magnitude(array)

  puts "PART 1: #{mag}" if printable

  mag
end

def part_2_solution(values)
  max = 0
  values.permutation(2).each do |pair|
    mag = magnitude(eval(add(*pair)))

    max = mag if max < mag
  end

  puts "PART 2: #{max}"
end