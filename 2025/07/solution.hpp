#pragma once
#include "../common/aoc.hpp"

namespace day07 {

#define START 'S'
#define SPLITTER '^'

int part1(const AOC::Vec2 start, const size_t height, const std::set<AOC::Vec2>& splitters) {
  std::set<AOC::Vec2> beams = { start };
  int splits = 0;
  bool finished = false;

  for (auto splitter : splitters) {
  }

  while (!finished) {
    std::set<AOC::Vec2> new_beams = {};
    size_t beams_finished = 0;

    for (AOC::Vec2 beam : beams) {
      AOC::Vec2 new_beam = beam.add(AOC::Vec2::DOWN());

      if (splitters.find(new_beam) != splitters.end()) {
        splits++;

        AOC::Vec2 split_left  = new_beam.add(AOC::Vec2::LEFT());
        AOC::Vec2 split_right = new_beam.add(AOC::Vec2::RIGHT());

        new_beams.insert(split_left);
        new_beams.insert(split_right);
      }
      else {
        new_beams.insert(new_beam);

        if (new_beam.y >= height - 1) { beams_finished++; }
      }
    }

    finished = beams_finished == beams.size();
    beams = new_beams;
  }

  return splits;
}

int part2(const AOC::Vec2 start, const size_t height, const std::set<AOC::Vec2>& splitters) {
  UNUSED(start); UNUSED(height); UNUSED(splitters);

  return 0;
}

void run(const std::string& input_file = "07/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::set<AOC::Vec2> splitters;
  AOC::Vec2 start;

  for (size_t y = 0; y < lines.size(); y++) {
    for (size_t x = 0; x < lines[y].size(); x++) {
      char c = lines[y][x];

      if (c == START) { start = AOC::Vec2(x, y); }
      if (c == SPLITTER) { splitters.insert(AOC::Vec2(x, y)); }
    }
  }

  int p1_result = part1(start, lines.size(), splitters);
  int p2_result = part2(start, lines.size(), splitters);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day07
