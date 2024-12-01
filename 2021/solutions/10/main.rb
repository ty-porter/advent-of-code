require_relative "../../utils.rb"

PAIR_MATCHERS = [
  /\[\]/,
  /\(\)/,
  /\{\}/,
  /\<\>/
]

CLOSING_SYMBOLS = ")]}>".chars
SYMBOL_PAIRS = "([{<".chars.zip(CLOSING_SYMBOLS).to_h

SYNTAX_SCORE_PT1 = CLOSING_SYMBOLS.zip([3, 57, 1197, 25137]).to_h
SYNTAX_SCORE_PT2 = CLOSING_SYMBOLS.zip([1, 2, 3, 4]).to_h

def first_closing_instance(str)
  str.chars.detect { |char| CLOSING_SYMBOLS.include?(char) }
end

def reduce_expression(str)
  return str unless PAIR_MATCHERS.any? { |pair| str.match?(pair) }

  PAIR_MATCHERS.each do |pair|
    str.gsub!(pair, "")
  end

  reduce_expression(str)
end

def part_1_solution(strs)
  value = strs.map do |str|
    reduced_expression = reduce_expression(str)
    closing_symbol = first_closing_instance(reduced_expression)

    SYNTAX_SCORE_PT1[closing_symbol] || 0
  end.sum

  puts "PART 1: #{value}"
end

def part_2_solution(strs)
  strs.select! do |str|     
    reduced_expression = reduce_expression(str)
    closing_symbol = first_closing_instance(reduced_expression)

    SYNTAX_SCORE_PT1[closing_symbol].nil?
  end

  scores = strs.map do |str|
    str.chars.map do |char|
      closing_symbol = SYMBOL_PAIRS[char]

      SYNTAX_SCORE_PT2[closing_symbol]
    end.reverse.reduce { |acc, cur| acc * 5 + cur }
  end

  value = scores.sort[scores.size / 2]

  puts "PART 2: #{value}"
end

test_strs = [
  '[({(<(())[]>[[{[]{<()<>>',
  '[(()[<>])]({[<{<<[]>>(',
  '{([(<{}[<>[]}>{[]{[(<()>',
  '(((({<>}<{<{<>}{[]{[]{}',
  '[[<[([]))<([[{}[[()]]]',
  '[{[{({}]{}}([{[{{{}}([]',
  '{<[[]]>}<{[{[{[]{()[[[]',
  '[<(<(<(<{}))><([]([]()',
  '<{([([[(<>()){}]>(<<{{',
  '<{([{{}}[<[[[<>{}]]]>[]]'
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt