#include "../common/aoc.hpp"

long pow(long i, int e) {
  if (e == 0) { return 1; }

  long r = 1;
  while (e--) r *= i;

  return r;
}

int part1(const std::vector<std::string>& lines) {
  int s = 0;

  for (auto line : lines) {
    auto it_left  = std::max_element(line.begin(), line.end() - 1);
    auto it_right = std::max_element(it_left + 1, line.end());

    s += (*it_left - '0') * 10 + (*it_right - '0');
  }

  return s;
}

long part2(const std::vector<std::string>& lines) {
  long s = 0;

  for (auto line : lines) {
    auto it = line.begin();
    int remaining = 12;
    long joltage = 0;

    while (remaining) {
      auto next_it = std::max_element(it, line.end() - remaining + 1);

      joltage += (*next_it - '0') * pow(10, remaining - 1);

      it = next_it + 1;
      remaining--;
    }

    s += joltage;
  }

  return s;
}

int main(int argc, char** argv) {
  std::string input_file = argc > 1 ? argv[1] : "prompt.txt";
  auto lines = AOC::read_lines(input_file);

  int p1_result = part1(lines);
  long p2_result = part2(lines);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}
