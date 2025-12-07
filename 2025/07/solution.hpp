#pragma once
#include "../common/aoc.hpp"

namespace day07 {

#define START 'S'
#define SPLITTER '^'

using DAG = std::map<AOC::Vec2, std::set<AOC::Vec2>>;

int part1(const DAG& dag) {
  std::set<AOC::Vec2> hits;

  for (auto it : dag) {
    hits.insert(it.first);
    if (it.second.size() > 0) hits.insert(it.second.begin(), it.second.end());
  }

  return hits.size();
}

int part2(const DAG& dag, const AOC::Vec2 root) {
  auto it = dag.find(root);

  if (it == dag.end()) return 0;

  std::set<AOC::Vec2> hits = it->second;
  int sum = 0;

  for (auto hit : hits) {
    sum += part2(dag, hit);
  }

  return 2 - hits.size() + sum;
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

    AOC::Vec2 left = splitter.add(AOC::Vec2::DOWNLEFT());

    while (left.y < height) {
      if (splitters.find(left) != splitters.end()) {
        dag[splitter].insert(left);
        queue.insert(left);
        break;
      }

      left = left.add(AOC::Vec2::DOWN());
    }

    
    AOC::Vec2 right = splitter.add(AOC::Vec2::DOWNRIGHT());

    while (right.y < height) {
      if (splitters.find(right) != splitters.end()) {
        dag[splitter].insert(right);
        queue.insert(right);
        break;
      }

      right = right.add(AOC::Vec2::DOWN());
    }
  }
  
  return dag;
}

void print_dag(const DAG& dag) {
  for (auto it : dag) {
    std::cout << it.first << std::endl;
    for (auto pos : it.second) {
      std::cout << '\t' << pos << std::endl;
    }
  }
}

void run(const std::string& input_file = "07/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::set<AOC::Vec2> splitters;
  AOC::Vec2 start;

  for (size_t y = 0; y < lines.size(); y++) {
    for (size_t x = 0; x < lines[y].size(); x++) {
      char c = lines[y][x];

      if (c == START) start = AOC::Vec2(x, y);
      if (c == SPLITTER) splitters.insert(AOC::Vec2(x, y));
    }
  }

  AOC::Vec2 root = get_root(start, splitters);
  DAG dag = build_dag(root, lines.size(), splitters);

  int p1_result = part1(dag);
  // int p2_result = part2(dag, root);
  int p2_result = 0;

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day07
