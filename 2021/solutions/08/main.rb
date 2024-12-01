require_relative "../../utils.rb"

def part_1_solution(strs)
  outputs = strs.map do |str| 
    segments = str.split(" | ").last.split

    segments.count do |segment|
      [2, 3, 4, 7].include?(segment.size)
    end
  end.sum
  
  puts "PART 1: #{outputs}"
end

def ONE(s)
  char(s, 2)
end

def SEVEN(s)
  char(s, 3)
end

def FOUR(s)
  char(s, 4)
end

def EIGHT(s)
  char(s, 7)
end

def char(s, size)
  s.detect { |s| s.size == size }.chars
end


def part_2_solution(strs)
  outputs = strs.map do |str| 
    signals, targets = str.split(" | ").map(&:split)

    nine_segments = signals.detect { |signal| signal.size == 6 && (signal.chars + FOUR(signals)).uniq.sort != EIGHT(signals).sort }
    bleft = (EIGHT(signals) - nine_segments.chars).first

    six_segments = signals.detect { |signal| signal.size == 6 && (signal.chars + ONE(signals)).uniq.sort == EIGHT(signals).sort }
    tright = (EIGHT(signals) - six_segments.chars).first

    targets.map do |segment|
      next 1 if segment.size == 2
      next 2 if segment.size == 5 && segment.match?(bleft) && segment.match?(tright)
      next 3 if segment.size == 5 && !segment.match?(bleft) && segment.match?(tright)
      next 4 if segment.size == 4
      next 5 if segment.size == 5 && !segment.match?(bleft) && !segment.match?(tright)
      next 6 if segment.size == 6 && segment.match?(bleft) && !segment.match?(tright)
      next 7 if segment.size == 3
      next 8 if segment.size == 7
      next 9 if segment.size == 6 && !segment.match?(bleft) && segment.match?(tright)

      0
    end.join.to_i
  end

  puts "PART 2: #{outputs.sum}"
end

test_strs_single = [
  "acedgfb cdfbe gcdfa fbcad dab cefabd cdfgeb eafb cagedb ab | cdfeb fcadb cdfeb cdbaf"
]

test_strs = [
  'be cfbegad cbdgef fgaecd cgeb fdcge agebfd fecdb fabcd edb | fdgacbe cefdb cefbgd gcbe',
  'edbfga begcd cbg gc gcadebf fbgde acbgfd abcde gfcbed gfec | fcgedb cgb dgebacf gc',
  'fgaebd cg bdaec gdafb agbcfd gdcbef bgcad gfac gcb cdgabef | cg cg fdcagb cbg',
  'fbegcd cbd adcefb dageb afcb bc aefdc ecdab fgdeca fcdbega | efabcd cedba gadfec cb',
  'aecbfdg fbg gf bafeg dbefa fcge gcbea fcaegb dgceab fcbdga | gecf egdcabf bgf bfgea',
  'fgeab ca afcebg bdacfeg cfaedg gcfdb baec bfadeg bafgc acf | gebdcfa ecba ca fadegcb',
  'dbcfg fgd bdegcaf fgec aegbdf ecdfab fbedc dacgb gdcebf gf | cefg dcbef fcge gbcadfe',
  'bdfegc cbegaf gecbf dfcage bdacg ed bedf ced adcbefg gebcd | ed bcgafe cdgba cbgef',
  'egadfb cdbfeg cegd fecab cgb gbdefca cg fgcdab egfdb bfceg | gbdfcae bgc cg cgb',
  'gcafb gcf dcaebfg ecagb gf abcdeg gaef cafbge fdbac fegbdc | fgae cfgab fg bagce'
]

part_1_solution strs_from_prompt
part_2_solution strs_from_prompt