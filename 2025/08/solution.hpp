#pragma once
#include "../common/aoc.hpp"

namespace day08 {

using Vec3DDistance = std::pair<long, std::pair<AOC::Vec3D, AOC::Vec3D>>;

long part1(const std::vector<AOC::Vec3D>& boxes, const std::vector<Vec3DDistance>& distances, size_t threshold, size_t max_connections) {
  std::vector<std::set<AOC::Vec3D>> circuits;

  for (auto box : boxes) circuits.push_back({ box });

  size_t connected = 0;

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

    if (connected >= max_connections) break;
  }

  std::vector<size_t> smallest_circuits;

  for (auto circuit : circuits) smallest_circuits.push_back(circuit.size());

  std::sort(smallest_circuits.begin(), smallest_circuits.end(), std::greater<size_t>());

  long acc = 1;

  for (size_t i = 0; i < threshold; i++) acc *= smallest_circuits[i];

  return acc;
}

long part2(const std::vector<AOC::Vec3D>& boxes, const std::vector<Vec3DDistance>& distances) {
  std::vector<std::set<AOC::Vec3D>> circuits;

  for (auto box : boxes) circuits.push_back({ box });

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
        }
      }
      
      if (!removed) circuit++;
    }

    if (circuits.size() == 1) return box1.x * box2.x;
  }

  return 0;
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

  long p1_result = part1(boxes, distances, 3, 1000);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(boxes, distances);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day08
