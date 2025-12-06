#pragma once
#include "../common/aoc.hpp"

namespace day02 {

long pow(long i, int e) {
  if (e == 0) { return 1; }

  long r = 1;
  while (e--) r *= i;

  return r;
}

int digits(long i) {
  if (i == 0) return 1;

  int d = 0;
  for (; i; i /= 10) d++;

  return d;
}

long next_double(long i) {
  int d = digits(i);

  if (d % 2) return pow(10, d) + pow(10, d / 2);

  long sub1 = i / pow(10, d / 2);
  long sub2 = i % pow(10, d / 2);

  if (sub1 > sub2) return sub1 * pow(10, d / 2) + sub1;
  if (sub2 > sub1) return next_double((sub1 + 1) * pow(10, d / 2));

  // Break the tie
  return next_double(i + 1);
}

long next_repeat(long i) {
  int d = digits(i);

  // Handle single digit edge case
  if (d == 1) return next_repeat(10);

  int max_sz = d / 2;

  long sub = 0;
  long candidate = __LONG_MAX__;

  for (int sz = 1; sz <= max_sz; sz++) {
    sub *= 10;
    sub += (i / pow(10, d - sz)) % 10;

    if (d % sz > 0) continue;

    long c1 = 0;
    long c2 = 0;
    int sub_sz = digits(sub);
    int rollover_sz = digits(sub + 1);
    int sub_mul = pow(10, sub_sz);

    // Compute two numbers that are potential repeats c1 and c2.
    for (int d2 = 0; d2 < d / sub_sz; d2++) {
      c1 *= sub_mul; c2 *= sub_mul;
      c1 += sub;     c2 += sub + 1;
    }

    /*
    Rollover case. If the subsequence ends in 9, it rolls over and addition breaks.
      ex: if i is 99, at sz = 1, sub = 10, c2 = 110, and is not a repeat.
    */
    if (sub_sz < rollover_sz) {
      if (rollover_sz % 2 == 1) { c2 = next_double(c1); }
      else                      { c2 = next_repeat(c1 + 1); }
    }

    c1 = c1 < c2 && c1 > i ? c1 : c2;

    if (c1 < candidate) candidate = c1;
  }

  return candidate;
}

long part1(const std::vector<std::pair<long, long>>& ranges) {
  long invalid = 0;

  for (std::pair<long, long> range : ranges) {
    // Inclusivity check, next_double() lands on the start of range if it's a repeat
    long start = range.first - 1;
    long stop = range.second;

    while (1) {
      start = next_double(start);

      if (start > stop) break;

      invalid += start;
    }
  }

  return invalid;
}

long part2(const std::vector<std::pair<long, long>>& ranges) {
  long invalid = 0;

  for (std::pair<long, long> range : ranges) {
    // Inclusivity check, next_double() lands on the start of range if it's a repeat
    long start = range.first - 1;
    long stop = range.second;

    while (1) {
      start = next_repeat(start);

      if (start > stop) break;

      invalid += start;
    }
  }

  return invalid;
}

void run(const std::string& input_file = "02/prompt.txt") {
  auto file = AOC::read_file(input_file);
  std::vector<std::string_view> range_strings = AOC::split(file, ',');
  std::vector<std::pair<long, long>> ranges;

  for (auto range_string : range_strings) {
    std::vector<std::string_view> range = AOC::split(range_string, '-');

    long start = std::stol(std::string(range[0]));
    long stop  = std::stol(std::string(range[1]));

    ranges.push_back(std::make_pair(start, stop));
  }

  long p1_result = part1(ranges);
  long p2_result = part2(ranges);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day02
