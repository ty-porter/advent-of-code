#pragma once
#include "../common/aoc.hpp"

namespace day07 {

#define START 'S'
#define SPLITTER '^'

using DAG = std::map<AOC::Vec2D, std::set<AOC::Vec2D>>;
std::map<AOC::Vec2D, long> p2memo;

int part1(const DAG& dag) {
  std::set<AOC::Vec2D> hits;

  for (auto it : dag) {
    hits.insert(it.first);
    if (it.second.size() > 0) hits.insert(it.second.begin(), it.second.end());
  }

  return hits.size();
}

long part2(const DAG& dag, const AOC::Vec2D root) {
  if (p2memo.find(root) != p2memo.end()) return p2memo[root];

  std::set<AOC::Vec2D> hits = dag.find(root)->second;
  long paths = 2;

  for (auto hit : hits) {
    paths += part2(dag, hit) - 1;
  }

  p2memo[root] = paths;
  return paths;
}

AOC::Vec2D get_root(const AOC::Vec2D start, const std::set<AOC::Vec2D>& splitters) {
  AOC::Vec2D pos = AOC::Vec2D::add(AOC::Vec2D(), start);

  while (splitters.find(pos) == splitters.end()) {
    pos = AOC::Vec2D::add(AOC::Vec2D::DOWN(), pos);
  }

  return pos;
}

DAG build_dag(const AOC::Vec2D root, const size_t height, const std::set<AOC::Vec2D>& splitters) {
  DAG dag;
  std::set<AOC::Vec2D> queue = { root };
  std::set<AOC::Vec2D> seen  = {};

  while (!queue.empty()) {
    auto front = queue.extract(queue.begin());
    AOC::Vec2D splitter = front.value();

    if (seen.find(splitter) != seen.end()) continue;

    seen.insert(splitter);

    if (dag.find(splitter) == dag.end()) {
      dag[splitter] = {};
    }

    AOC::Vec2D left = AOC::Vec2D::add(splitter, AOC::Vec2D(-1, 2));

    while (left.y < height) {
      if (splitters.find(left) != splitters.end()) {
        dag[splitter].insert(left);
        queue.insert(left);
        break;
      }

      left = AOC::Vec2D::add(left, AOC::Vec2D(0, 2));
    }

    AOC::Vec2D right = AOC::Vec2D::add(splitter, AOC::Vec2D(1, 2));

    while (right.y < height) {
      if (splitters.find(right) != splitters.end()) {
        dag[splitter].insert(right);
        queue.insert(right);
        break;
      }

      right = AOC::Vec2D::add(right, AOC::Vec2D(0, 2));
    }
  }
  
  return dag;
}

void run(const std::string& input_file = "07/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::set<AOC::Vec2D> splitters;
  AOC::Vec2D start;

  for (size_t y = 0; y < lines.size(); y++) {
    for (size_t x = 0; x < lines[y].size(); x++) {
      char c = lines[y][x];

      if (c == START)    start = AOC::Vec2D(x, y);
      if (c == SPLITTER) splitters.insert(AOC::Vec2D(x, y));
    }
  }

  AOC::Vec2D root = get_root(start, splitters);
  DAG dag = build_dag(root, lines.size() - 1, splitters);

  int p1_result = part1(dag);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(dag, root);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day07
