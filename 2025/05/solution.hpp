#pragma once
#include "../common/aoc.hpp"

namespace day05 {

int part1(const std::vector<std::pair<long, long>> ranges, const std::vector<long> ids) {
  int sum = 0;

  for (long id : ids) {
    for (std::pair<long, long> range : ranges) {
      if (id >= range.first && id <= range.second) {
        sum++; break;
      }
    }
  }

  return sum;
}

long part2(const std::vector<std::pair<long, long>> ranges) {
  long sum = 0;

  std::pair<long, long> r1;
  std::pair<long, long> r2;

  // Iterate over sorted ranges, merging where possible.
  // If a merge isn't possible, dump the size of the range (endpoint inclusive) to the total and start a new range.
  for (size_t i = 0; i < ranges.size(); i++) {
    if (i == 0) {
      r1 = ranges[i];
      continue;
    }

    r2 = ranges[i];

    if (r1.second >= r2.first) {
      if (r1.second < r2.second) {
        r1.second = r2.second;
      }

      continue;
    }

    sum += r1.second - r1.first + 1;
    r1 = r2;
  }

  sum += r1.second - r1.first + 1;

  return sum;
}

void run(const std::string& input_file = "05/prompt.txt") {
  auto file = AOC::read_file(input_file);

  std::vector<std::string_view> halves = AOC::substring_split(file, "\n\n");

  std::vector<std::string_view> range_lines = AOC::split(halves[0], '\n');
  std::vector<std::string_view> id_lines = AOC::split(halves[1], '\n');

  std::vector<std::pair<long, long>> ranges;
  std::vector<long> ids;

  for (auto range_line : range_lines) {
    auto range = AOC::split(range_line, '-');
    long range_start = std::stol(std::string(AOC::trim(range[0])));
    long range_stop  = std::stol(std::string(AOC::trim(range[1])));

    ranges.push_back(std::make_pair(range_start, range_stop));
  }

  std::sort(ranges.begin(), ranges.end());

  for (auto id_line : id_lines) {
    ids.push_back(std::stol(std::string(AOC::trim(id_line))));
  }

  int p1_result = part1(ranges, ids);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(ranges);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day05
