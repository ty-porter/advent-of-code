#pragma once
#include "../common/aoc.hpp"

namespace day11 {

using Graph = std::unordered_map<std::string, std::vector<std::string>>;
using Memo = std::map<std::pair<std::string, std::string>, size_t>;

size_t count_paths(const std::string& pos, const std::string& target,
                   const Graph& graph, Memo& memo) {
  auto key = std::make_pair(pos, target);
  if (memo.count(key)) {
    return memo[key];
  }

  if (pos == target) {
    return 1;
  }

  size_t total = 0;
  auto it = graph.find(pos);
  if (it != graph.end()) {
    for (const std::string& neighbor : it->second) {
      total += count_paths(neighbor, target, graph, memo);
    }
  }

  memo[key] = total;
  return total;
}

size_t part1(const Graph& graph) {
  Memo memo;
  return count_paths("you", "out", graph, memo);
}

size_t part2(const Graph& graph) {
  Memo memo;

  long path1 = count_paths("svr", "fft", graph, memo)
               * count_paths("fft", "dac", graph, memo)
               * count_paths("dac", "out", graph, memo);

  long path2 = count_paths("svr", "dac", graph, memo)
               * count_paths("dac", "fft", graph, memo)
               * count_paths("fft", "out", graph, memo);

  return path1 + path2;
}

void run(const std::string& input_file = "11/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  Graph graph;

  for (auto line : lines) {
    auto parts = AOC::substring_split(line, ": ");
    std::string vertex = static_cast<std::string>(parts[0]);
    graph[vertex] = {};

    for (auto adjacent : AOC::split(parts[1], ' ')) {
      graph[vertex].push_back(static_cast<std::string>(adjacent));
    }
  }

  size_t p1_result = part1(graph);
  std::cout << "Part 1: " << p1_result << std::endl;

  size_t p2_result = part2(graph);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day11
