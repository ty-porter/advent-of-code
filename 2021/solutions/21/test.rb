def next_spot(loc, roll)
    (loc + roll) % 10 == 0 ? 10 : (loc + roll) % 10
  end
  
  dice = [*1..100] * 1000
  counter = pl1_score = pl2_score = 0
  player1 = 6
  player2 = 8
  dice.each_slice(3) do |a|
    counter += 1
    if counter % 2 == 1
      player1 = next_spot(player1, a.sum)
      pl1_score += player1
      if pl1_score >= 1000
        puts counter * 3 * pl2_score
        break
      end
    else
      player2 = next_spot(player2, a.sum)
      pl2_score += player2
      if pl2_score >= 1000
        puts counter * 3 * pl1_score
        break
      end
    end
  end
  
  # Part 2
  
  def scenarios(pl1, pl2, pl1_needed, pl2_needed, player_turn, cache)
    outcomes = {3 => 1, 4 => 3, 5 => 6, 6 => 7, 7 => 6, 8 => 3, 9 => 1}
    if pl1_needed <= 0
      return 1
    elsif pl2_needed <= 0
      return 1.i
    end
    output = cache[[pl1, pl2, pl1_needed, pl2_needed, player_turn]]
    if !output
      output = 0
      if player_turn == 1
        outcomes.keys.each{|k| output += scenarios(next_spot(pl1, k), pl2, pl1_needed - next_spot(pl1, k), pl2_needed, 2, cache) * outcomes[k]}
      elsif player_turn == 2
        outcomes.keys.each{|k| output += scenarios(pl1, next_spot(pl2, k), pl1_needed, pl2_needed - next_spot(pl2, k), 1, cache) * outcomes[k]}
      end
    end
    cache[[pl1, pl2, pl1_needed, pl2_needed, player_turn]] = output
    return output
  end
  
  stamp = Time.now
  scenarios(6, 8, 21, 21, 1, Hash.new).tap{ |_1| puts [_1.real, _1.imaginary].max }
  p Time.now - stamp