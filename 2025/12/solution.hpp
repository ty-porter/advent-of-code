#pragma once
#include "../common/aoc.hpp"

namespace day12 {

size_t part1(const std::vector<std::string>& lines) {
  size_t valid = 0;

  for (auto line : lines) {
    auto parts = AOC::substring_split(line, ": ");

    auto size = AOC::split(static_cast<std::string>(parts[0]), 'x');

    size_t area = std::stoi(static_cast<std::string>(size[0])) * std::stoi(static_cast<std::string>(size[1]));
    size_t sum = 0;

    for (auto amt : AOC::split(parts[1], ' ')) {
      sum += std::stoi(static_cast<std::string>(amt));
    }

    if (9 * sum <= area) valid++;
  }

  return valid;
}

void run(const std::string& input_file = "12/prompt.txt") {
  auto file = AOC::read_file(input_file);
  std::vector<std::string_view> file_parts = AOC::substring_split(file, "\n\n");
  std::vector<std::string_view> _lines = AOC::split(file_parts[file_parts.size() - 1], '\n');
  std::vector<std::string> lines;

  for (auto line : _lines) {
    lines.push_back(static_cast<std::string>(line));
  }

  long p1_result = part1(lines);
  std::cout << "Part 1: " << p1_result << std::endl;
}

} // namespace day12
