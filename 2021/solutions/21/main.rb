require_relative "../../utils.rb"

$cache = {}
OUTCOMES = {
  3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1
}.freeze

def new_position(pos, roll)
  (pos + roll) % 10 == 0 ? 10 : (pos + roll) % 10
end

def quantum_game(positions, scores, turn = 0)
  return $cache[[positions, scores, turn]] if $cache[[positions, scores, turn]]

  if scores.first >= 21
    return [1, 0]
  elsif scores.last >= 21
    return [0, 1]
  end

  output = $cache[[positions, scores, turn]]

  if !output
    output = [0, 0]

    if turn == 0
      OUTCOMES.each do |value, amt| 
        new_positions = [new_position(positions.first, value), positions.last]
        new_scores = [scores.first + new_positions.first, scores.last]
        new_wins = quantum_game(new_positions, new_scores, 1)
        new_wins = [new_wins.first * amt, new_wins.last]

        output = output.zip(new_wins).map(&:sum)
      end
    else
      OUTCOMES.each do |value, amt| 
        new_positions = [positions.first, new_position(positions.last, value)]
        new_scores = [scores.first, scores.last + new_positions.last]
        new_wins = quantum_game(new_positions, new_scores, 0)
        new_wins = [new_wins.first, new_wins.last * amt]

        output = output.zip(new_wins).map(&:sum)
      end
    end
  end

  $cache[[positions, scores, turn]] = output

  output
end

def part_1_solution(p1_pos, p2_pos)
  p1_score = 0
  p2_score = 0
  die  = 1
  turn = 0

  result = nil

  while result.nil?
    die_faces = (die..die + 2).map { |face| face > 100 ? face % 100 : face }
    die_sum   = die_faces.sum

    if turn % 2 == 0
      p1_pos   += die_sum
      p1_pos   -= 10 while p1_pos > 10
      p1_score += p1_pos
    else
      p2_pos   += die_sum
      p2_pos   -= 10 while p2_pos > 10
      p2_score += p2_pos
    end

    turn += 1
    die   = die + 3 > 100 ? (die + 3) % 100 : die + 3

    if p1_score >= 1000 || p2_score >= 1000
      result = [p1_score, p2_score].sort.first * turn * 3
    end
  end

  puts "PART 1: #{result}"
end

def part_2_solution(p1_pos, p2_pos)
  wins = quantum_game([p1_pos, p2_pos], [0, 0])

  puts "PART 2: #{wins.max}"
end

part_1_solution 6, 8
part_2_solution 4, 8