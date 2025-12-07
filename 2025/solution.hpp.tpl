#pragma once
#include "../common/aoc.hpp"

namespace day{{DAY}} {

long part1(const std::vector<std::string>& lines) {
  UNUSED(lines);

  return 0;
}

long part2(const std::vector<std::string>& lines) {
  UNUSED(lines);

  return 0;
}

void run(const std::string& input_file = "{{DAY}}/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  long p1_result = part1(lines);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(lines);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day{{DAY}}
