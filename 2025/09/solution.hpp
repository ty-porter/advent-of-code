#pragma once
#include "../common/aoc.hpp"

namespace day09 {

bool line_intersects(const AOC::Box2D& box, const AOC::Vec2D& l1, const AOC::Vec2D& l2) {
  auto bmax = box.getMax();
  auto bmin = box.getMin();

  if (l1.x == l2.x) {
    if (l1.x <= bmin.x || l1.x >= bmax.x) return false;
    return std::max(l1.y, l2.y) > bmin.y && std::min(l1.y, l2.y) < bmax.y;
  } else if (l1.y == l2.y) {
    if (l1.y <= bmin.y || l1.y >= bmax.y) return false;
    return std::max(l1.x, l2.x) > bmin.x && std::min(l1.x, l2.x) < bmax.x;
  }

  // Diagonal lines not supported
  return false;
}

long part2(const std::vector<AOC::Box2D>& boxes, const std::vector<AOC::Vec2D>& tiles) {
  for (auto box: boxes) {
    bool intersects = false;
    size_t i = 0;

    while (!intersects && i < tiles.size()) {
      size_t j = i == tiles.size() - 1 ? 0 : i + 1;
      intersects = line_intersects(box, tiles[i], tiles[j]);
      i++;
    }

    if (!intersects) return box.area();
  }

  return -1;
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
