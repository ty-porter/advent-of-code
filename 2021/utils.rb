require 'pry'

def prompt_data
  File.open("prompt.txt")
end

def nums_from_prompt
  prompt_data.readlines.map { |num| num.chomp.to_i }
end

def num_groups_from_prompt
  prompt_data.readlines.map { |str| str.chars.map(&:to_i) }
end

def strs_from_prompt
  prompt_data.readlines.map(&:chomp)
end

def str_groups_from_prompt
  strs_from_prompt.chunk_while do |cur, prv|
    cur != ""
  end.map do |group|
    group.reject { |str| str == "" }
  end
end

def str_single_from_prompt(index = 0)
  strs_from_prompt[index]
end

def arys_from_prompt
  prompt_data.readlines.map { |str| eval(str.chomp) }
end

class Array
  # Prints a 2D array representation
  def p2d(delimiter: ",", max_size: nil)
    size = max_size || flatten.map do |cell|
      if cell.is_a?(Integer)
        cell.digits.size
      elsif cell.is_a?(String)
        cell.size
      end
    end.max

    string = map do |row|
      row.map { |cell| cell.to_s.rjust(size) }.join(delimiter)
    end.join("\n") + "\n"

    puts string
  end
end

class Color
  RED     = 31
  GREEN   = 32
  YELLOW  = 33
  BLUE    = 34
  MAGENTA = 35
  CYAN    = 36
end

def colorize(text, color_code)
  "\e[#{color_code}m#{text}\e[0m"
end

def test(label, actual, expected)
  puts "TEST: #{label}"
  puts colorize("Expected #{expected}, got #{actual}.", actual == expected ? Color::GREEN : Color::RED)
end