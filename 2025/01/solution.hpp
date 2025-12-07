#pragma once
#include "../common/aoc.hpp"

namespace day01 {

int part1(const std::vector<std::string>& lines) {
  int dial = 50;
  int pw = 0;

  for (auto line : lines) {
    char dir = line[0];
    int amt = std::stoi(line.substr(1));
    int delta = (dir == 'L' ? -1 : 1) * amt;

    dial = (dial + delta) % 100;

    if (dial < 0) dial += 100;
    if (dial == 0) pw++;
  }

  return pw;
}

int part2(const std::vector<std::string>& lines) {
  int dial = 50;
  int pw = 0;

  for (auto line : lines) {
    char dir = line[0];
    int amt = std::stoi(line.substr(1));
    int delta = (dir == 'L' ? -1 : 1) * amt;

    int crossings = 0;

    int zero_dist = dir == 'R' ? (100 - dial) % 100 : dial;
    if (zero_dist == 0) zero_dist = 100;
    if (zero_dist <= amt) {
      crossings = (amt - zero_dist) / 100 + 1;
    }

    dial = (dial + delta) % 100;

    if (dial < 0) dial += 100;

    pw += crossings;
  }

  return pw;
}

void run(const std::string& input_file = "01/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  int p1_result = part1(lines);
  std::cout << "Part 1: " << p1_result << std::endl;

  int p2_result = part2(lines);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day01
