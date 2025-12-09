#pragma once
#include "../common/aoc.hpp"

namespace day09 {

long part2(const std::vector<AOC::Box2D>& boxes, const std::vector<AOC::Vec2D>& tiles) {
  for (auto box: boxes) {
    bool hit = false;

    for (size_t i = 0; i < tiles.size(); i++) {
      // Check for hit
    }

    if (!hit) return box.area();
  }

  return 0;
}

void run(const std::string& input_file = "09/prompt.txt") {
  auto lines = AOC::read_lines(input_file);
  std::vector<AOC::Vec2D> tiles;

  for (auto line : lines) {
    std::vector<std::string_view> axes = AOC::split(line, ',');

    AOC::Vec2D tile = AOC::Vec2D(
      std::stoi(std::string(axes[0])),
      std::stoi(std::string(axes[1]))
    );

    tiles.push_back(tile);
  }

  std::vector<AOC::Box2D> boxes;

  for (size_t i = 0; i < tiles.size(); i++) {
    for (size_t j = i + 1; j < tiles.size(); j++) {
      boxes.push_back(AOC::Box2D(tiles[i], tiles[j]));
    }
  }

  std::sort(boxes.begin(), boxes.end(), 
    [](AOC::Box2D a, AOC::Box2D b) { return a.area() > b.area(); }
  );

  long p1_result = boxes[0].area();
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(boxes, tiles);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day09
