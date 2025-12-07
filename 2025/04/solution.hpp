#pragma once
#include "../common/aoc.hpp"

namespace day04 {

#define THRESHOLD 4

const std::vector<std::pair<int, int>> offsets = {
  { 1,  0 },
  { 1,  1 },
  { 1, -1 },
  { 0,  1 },
  { 0, -1 },
  {-1,  0 },
  {-1,  1 },
  {-1, -1 },
};

int count_adjacent(const std::vector<std::string>& grid, int x, int y) {
  int s = 0;

  for (std::pair<int, int> offset : offsets) {
    int X = x + offset.first;
    int Y = y + offset.second;

    if (Y < 0 || Y >= (int)grid.size()) continue;
    if (X < 0 || X >= (int)grid[Y].size()) continue;
    if (grid[Y][X] != '@') continue;

    s++;
  }

  return s;
}

int part1(const std::vector<std::string>& grid) {
  int s = 0;

  for (size_t y = 0; y < grid.size(); y++) {
    for (size_t x = 0; x < grid[y].size(); x++) {
      if (grid[y][x] != '@') continue;

      if (count_adjacent(grid, x, y) < THRESHOLD) s++;
    }
  }

  return s;
}

int part2(std::vector<std::string>& grid) {
  std::vector<std::pair<int, int>> removed;

  for (size_t y = 0; y < grid.size(); y++) {
    for (size_t x = 0; x < grid[y].size(); x++) {
      if (grid[y][x] != '@') continue;

      if (count_adjacent(grid, x, y) < THRESHOLD) removed.push_back(std::make_pair(x, y));
    }
  }

  if (removed.size() > 0) {
    for (auto position : removed) {
      grid[position.second][position.first] = '.';
    }

    return removed.size() + part2(grid);
  }

  return 0;
}

void run(const std::string& input_file = "04/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  int p1_result = part1(lines);
  std::cout << "Part 1: " << p1_result << std::endl;

  // Make a copy for part2 since it modifies the grid
  auto lines_copy = lines;
  int p2_result = part2(lines_copy);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day04
