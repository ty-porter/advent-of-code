require_relative "../../utils.rb"

class Bingo
  class Number
    def initialize(value, marked)
      @value = value.to_i
      @marked = marked
    end

    attr_reader :value
    attr_accessor :marked
  end

  def initialize(board, marked: false)
    @board = board.map do |group|
      group.split().map { |value| Bingo::Number.new(value, marked) }
    end
  end

  def mark(value)
    @board.each do |row|
      row.each do |col|
        col.marked = true if col.value == value
      end
    end
  end

  def unmark(value)
    @board.each do |row|
      row.each do |col|
        col.marked = false if col.value == value
      end
    end
  end

  def won?
    # Horizontal
    return true if @board.any? { |row| row.all?(&:marked) }
    
    # Vertical
    return true if @board.transpose.any? { |col| col.all?(&:marked) }

    false
  end

  def unmarked_numbers
    @board.flatten.reject(&:marked).map(&:value)
  end

  def to_s(highlight_marked: false)
    @board.map do |row|
      row.map do |col|
        if highlight_marked && col.marked
          "#{col.value} (M)"
        else
          col.value
        end
      end.join(",")
    end.join("\n")
  end
end

def determine_first_winner(input, boards)
  input.each do |value|
    boards.each do |board|
      board.mark(value)

      return [value, board] if board.won?
    end
  end
end

def determine_last_winner(input, boards)
  input.each do |value|
    boards.each do |board|
      board.mark(value)
    end
  end

  input.reverse.each do |value|
    boards.each do |board|
      won = board.won?
      board.unmark(value)

      if !board.won? && won
        board.mark(value) # Re-mark it for calculations

        return [value, board]
      end
    end
  end
end

def part_1_solution(groups)
  input = groups.first.first.split(",").map(&:to_i)
  board_groups = groups[1, groups.size]

  boards = board_groups.map { |group| Bingo.new(group) }
  winning_value, winner = determine_first_winner(input, boards)

  puts "PART 1: #{winner.unmarked_numbers.sum * winning_value}"
end

def part_2_solution(groups)
  input = groups.first.first.split(",").map(&:to_i)
  board_groups = groups[1, groups.size]

  boards = board_groups.map { |group| Bingo.new(group, marked: true) }
  winning_value, winner = determine_last_winner(input, boards)

  puts "PART 2: #{winner.unmarked_numbers.sum * winning_value}"
end

part_1_solution str_groups_from_prompt
part_2_solution str_groups_from_prompt