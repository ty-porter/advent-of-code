#pragma once
#include "../common/aoc.hpp"

namespace day07 {

#define START 'S'
#define SPLITTER '^'

using DAG = std::map<AOC::Vec2, std::set<AOC::Vec2>>;
std::map<AOC::Vec2, int> p2memo;

int part1(const DAG& dag) {
  std::set<AOC::Vec2> hits;

  for (auto it : dag) {
    hits.insert(it.first);
    if (it.second.size() > 0) hits.insert(it.second.begin(), it.second.end());
  }

  return hits.size();
}

int part2(const DAG& dag, const AOC::Vec2 root) {
  if (p2memo.find(root) != p2memo.end()) return p2memo[root];
  
  std::set<AOC::Vec2> hits = dag.find(root)->second;
  int paths = 2;

  for (auto hit : hits) {
    paths += part2(dag, hit) - 1;
  }

  p2memo[root] = paths;
  return paths;
}

AOC::Vec2 get_root(const AOC::Vec2 start, const std::set<AOC::Vec2>& splitters) {
  AOC::Vec2 pos = AOC::Vec2().add(start);

  while (splitters.find(pos) == splitters.end()) {
    pos = pos.add(AOC::Vec2::DOWN());
  }

  return pos;
}

DAG build_dag(const AOC::Vec2 root, const size_t height, const std::set<AOC::Vec2>& splitters) {
  DAG dag;
  std::set<AOC::Vec2> queue = { root };
  std::set<AOC::Vec2> seen  = {};

  while (!queue.empty()) {
    auto front = queue.extract(queue.begin());
    AOC::Vec2 splitter = front.value();

    if (seen.find(splitter) != seen.end()) continue;

    seen.insert(splitter);

    if (dag.find(splitter) == dag.end()) {
      dag[splitter] = {};
    }

    AOC::Vec2 left = splitter.add(AOC::Vec2(-1, 2));

    while (left.y < height) {
      if (splitters.find(left) != splitters.end()) {
        dag[splitter].insert(left);
        queue.insert(left);
        break;
      }

      left = left.add(AOC::Vec2(0, 2));
    }

    AOC::Vec2 right = splitter.add(AOC::Vec2(1, 2));

    while (right.y < height) {
      if (splitters.find(right) != splitters.end()) {
        dag[splitter].insert(right);
        queue.insert(right);
        break;
      }

      right = right.add(AOC::Vec2(0, 2));
    }
  }
  
  return dag;
}

void run(const std::string& input_file = "07/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::set<AOC::Vec2> splitters;
  AOC::Vec2 start;

  for (size_t y = 0; y < lines.size(); y++) {
    for (size_t x = 0; x < lines[y].size(); x++) {
      char c = lines[y][x];

      if (c == START)    start = AOC::Vec2(x, y);
      if (c == SPLITTER) splitters.insert(AOC::Vec2(x, y));
    }
  }

  AOC::Vec2 root = get_root(start, splitters);
  DAG dag = build_dag(root, lines.size() - 1, splitters);

  int p1_result = part1(dag);
  std::cout << "Part 1: " << p1_result << std::endl;

  int p2_result = part2(dag, root);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day07
