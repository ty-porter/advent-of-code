require_relative "../../utils.rb"

def part_1_solution(values, steps: 10, printable: true)
  pairs = []
  polymer = values.first.first

  polymer.chars.each_with_index do |atom, i|
    break if i == polymer.size - 1

    pairs << atom + polymer[i + 1]
  end

  pair_counts = {}

  rules = values.last.map do |rule| 
    pair, insertion = rule.split(" -> ")
    results = [pair[0] + insertion, insertion + pair[1]]

    pair_counts[pair] = pairs.count(pair)
    [pair, results]
  end.to_h

  steps.times do |step|
    new_counts = {}

    pair_counts.each do |pair, count|
      rules[pair].each do |rule_pair|
        new_counts[rule_pair] = 0 unless new_counts.include?(rule_pair)
        new_counts[rule_pair] += count
      end
    end

    pair_counts = new_counts
  end

  atom_counts = {}

  pair_counts.each do |pair, count|
    atom = pair[0]
    atom_counts[atom] = 0 unless atom_counts.include?(atom)
    atom_counts[atom] += count
  end

  last_atom = polymer[-1]

  atom_counts[last_atom] = 0 unless atom_counts.include?(last_atom)
  atom_counts[last_atom] += 1

  min, max = atom_counts.values.minmax

  puts "PART 1: #{max - min}" if printable

  max - min
end

def part_2_solution(values)
  value = part_1_solution(values, steps: 40, printable: false)

  puts "PART 2: #{value}"
end

test_polymer = ["NNCB"]
test_rules = [
  "CH -> B",
  "HH -> N",
  "CB -> H",
  "NH -> C",
  "HB -> C",
  "HC -> B",
  "HN -> C",
  "NN -> C",
  "BH -> H",
  "NC -> B",
  "NB -> B",
  "BN -> B",
  "BB -> N",
  "BC -> B",
  "CC -> N",
  "CN -> C"
]

test_strs = [test_polymer, test_rules]

part_1_solution str_groups_from_prompt
part_2_solution str_groups_from_prompt