require_relative "utils.rb"

puts colorize("Printing Advent of Code solutions for 2021!", Color::YELLOW)

Dir.glob("solutions/*").select {|f| File.directory? f }.each_with_index do |solution, index|
  Dir.chdir(solution) do
    indent = " " * 2
    
    puts if index > 0
    puts indent + colorize("- DAY #{solution.split("/").last.to_i}", Color::CYAN)

    results = `ruby main.rb`

    puts results.split("\n").map { |line| colorize(indent * 3 + line, Color::YELLOW) }
  end
end