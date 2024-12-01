require_relative "../../utils.rb"

def part_1_solution(_, _, y_min, _)
  puts "PART 1: #{(y_min * (y_min + 1)) / 2}"
end

def part_2_solution(x_min, x_max, y_min, y_max)
  value = 0
  total = 0
  
  (1..x_max + 1).each do |v0x|
    (y_min..-y_min).each do |v0y|
      x, y   = [0, 0]
      vx, vy = [v0x, v0y]

      while x <= x_max && y >= y_min
        if x >= x_min && y <= y_max
          total += 1

          break
        end

        x, y = [x + vx, y + vy] 

        if vx > 0
          vx -= 1
        end
        vy -= 1
      end
    end
  end

  puts "PART 2: #{total}"
end

test_params = 20, 30, -10, -5
prompt_params = 156, 202, -110, -69

part_1_solution *prompt_params
part_2_solution *prompt_params