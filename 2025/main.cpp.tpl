#include "../common/aoc.hpp"

int part1(const std::vector<std::string>& lines) {
  UNUSED(lines);

  return 0;
}

int part2(const std::vector<std::string>& lines) {
  UNUSED(lines);

  return 0;
}

int main(int argc, char** argv) {
  std::string input_file = argc > 1 ? argv[1] : "prompt.txt";
  auto lines = AOC::read_lines(input_file);

  int p1_result = part1(lines);
  int p2_result = part2(lines);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}
