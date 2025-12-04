#include "../common/aoc.hpp"

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
    size_t X, Y;

    X = x + offset.first;
    Y = y + offset.second;

    if (X >= grid.size() || Y >= grid[Y].size() || grid[Y][X] != '@') continue;

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

int main(int argc, char** argv) {
  std::string input_file = argc > 1 ? argv[1] : "prompt.txt";
  auto lines = AOC::read_lines(input_file);

  int p1_result = part1(lines);
  int p2_result = part2(lines);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}
