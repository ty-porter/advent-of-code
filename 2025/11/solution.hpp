#pragma once
#include "../common/aoc.hpp"

namespace day11 {

using Path = std::set<std::string>;
using Graph = std::unordered_map<std::string, Path>;

void dfs(
  const std::string& src, 
  const std::string& dst, 
  const Graph& graph, 
  Path& path, 
  std::vector<Path>& paths, 
  Path& visited
) {
  path.insert(src);

  visited.insert(src);
  if (src == dst) {
    paths.push_back(path);
  } else {
    for (std::string adjacent : graph.find(src)->second) {
      dfs(adjacent, dst, graph, path, paths, visited);
    }
  }

  path.erase(src);
}

size_t part1(const Graph& graph) {
  std::vector<Path> paths;
  Path path;
  Path visited;

  dfs("you", "out", graph, path, paths, visited);

  return paths.size();
}

size_t part2(const Graph& graph) {
  std::vector<Path> paths;
  Path path;
  Path visited;

  dfs("svr", "out", graph, path, paths, visited);

  size_t valid = 0;

  for (auto p : paths) {
    short state = 0;

    for (auto node : p) {
      if (node == "dac") state |= 1;
      if (node == "fft") state |= 2;

      if (state == 3) {
        valid++;
        break;
      }
    }
  }

  return valid;
}

void run(const std::string& input_file = "11/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  Graph graph;

  for (auto line : lines) {
    auto parts = AOC::substring_split(line, ": ");

    std::string vertex = static_cast<std::string>(parts[0]);

    graph[vertex] = {};

    for (auto adjacent : AOC::split(parts[1], ' ')) {
      graph[vertex].insert(static_cast<std::string>(adjacent));
    }
  }

  size_t p1_result = part1(graph);
  std::cout << "Part 1: " << p1_result << std::endl;

  size_t p2_result = part2(graph);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day11
