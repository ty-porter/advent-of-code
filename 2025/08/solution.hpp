#pragma once
#include "../common/aoc.hpp"

namespace day08 {

#define P1_MAX_CONNECTIONS 1000
#define P1_TOP_N_CIRCUITS 3

using Vec3DDistance = std::pair<long, std::pair<AOC::Vec3D, AOC::Vec3D>>;

long part1(const std::vector<std::set<AOC::Vec3D>>& circuits) {
  std::vector<size_t> largest;

  for (auto circuit : circuits) largest.push_back(circuit.size());

  std::sort(largest.begin(), largest.end(), std::greater<size_t>());

  return std::accumulate(largest.begin(), largest.begin() + P1_TOP_N_CIRCUITS, 1, std::multiplies<size_t>());
}

void run(const std::string& input_file = "08/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::vector<AOC::Vec3D> boxes;
  std::vector<Vec3DDistance> distances;

  for (auto line : lines) {
    std::vector<std::string_view> axes = AOC::split(line, ',');

    AOC::Vec3D box = AOC::Vec3D(
      std::stoi(std::string(axes[0])),
      std::stoi(std::string(axes[1])),
      std::stoi(std::string(axes[2]))
    );

    boxes.push_back(box);
  }

  for (size_t i = 0; i < boxes.size(); i++) {
    AOC::Vec3D box1 = boxes[i];

    for (size_t j = i+1; j < boxes.size(); j++) {
      AOC::Vec3D box2 = boxes[j];

      long dist = box1.sqdist(box2);

      distances.push_back(
        std::make_pair(dist, std::make_pair(box1, box2))
      );
    }
  }

  std::sort(distances.begin(), distances.end(),
    [](const Vec3DDistance a, const Vec3DDistance b) { return a.first < b.first; });

  std::vector<std::set<AOC::Vec3D>> circuits;

  for (auto box : boxes) circuits.push_back({ box });

  size_t connected = 0;
  long p1_result = 0;
  long p2_result = 0;

  for (Vec3DDistance d : distances) {
    AOC::Vec3D box1 = d.second.first;
    AOC::Vec3D box2 = d.second.second;

    auto found_circuit = circuits.end();

    for (auto circuit = circuits.begin(); circuit != circuits.end(); /* managed in loop */) {
      bool removed = false;

      if (circuit->find(box1) != circuit->end() || circuit->find(box2) != circuit->end()) {
        if (found_circuit != circuits.end()) {
          found_circuit->insert(circuit->begin(), circuit->end());
          circuits.erase(circuit);
          removed = true;
        } else {
          found_circuit = circuit;
          circuit->insert(box1); circuit->insert(box2);
          connected++;
        }
      }
      
      if (!removed) circuit++;
    }

    if (connected == P1_MAX_CONNECTIONS) p1_result = part1(circuits);
    if (circuits.size() == 1) {
      p2_result = box1.x * box2.x;
      break;
    }
  }

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day08
