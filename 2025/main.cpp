#include <chrono>
#include <iomanip>
#include <string>
#include <functional>
#include <vector>
#include <map>

#include "01/solution.hpp"
#include "02/solution.hpp"
#include "03/solution.hpp"
#include "04/solution.hpp"
#include "05/solution.hpp"
#include "06/solution.hpp"
#include "07/solution.hpp"
#include "08/solution.hpp"
#include "09/solution.hpp"
#include "10/solution.hpp"

const std::map<int, std::function<void()>> DAYS = {
  {1, []() { day01::run(); }},
  {2, []() { day02::run(); }},
  {3, []() { day03::run(); }},
  {4, []() { day04::run(); }},
  {5, []() { day05::run(); }},
  {6, []() { day06::run(); }},
  {7, []() { day07::run(); }},
  {8, []() { day08::run(); }},
  {9, []() { day09::run(); }},
  {10, []() { day10::run(); }},
};

struct DayResult {
  int day;
  double elapsed_ms;
};

double run_day_with_timing(std::function<void()> func) {
  auto start = std::chrono::high_resolution_clock::now();
  func();
  auto end = std::chrono::high_resolution_clock::now();

  std::chrono::duration<double, std::milli> elapsed = end - start;
  return elapsed.count();
}

void print_separator(bool thin=false) {
  if (thin) {
    std::cout << "-------------------------" << std::endl;
  } else {
    std::cout << "=========================" << std::endl;
  }
}

void print_header() {
  print_separator();
  std::cout << "|| Advent of Code 2025 ||" << std::endl;
  print_separator();
}

void print_timing(double ms) {
  std::cout << std::fixed << std::setprecision(3);
  std::cout << "Elapsed: " << ms << " ms" << std::endl;
}

double run_single_day(int day) {
  std::cout << "-<[ Day " << std::setw(2) << std::setfill('0') << day << " ]>-" << std::endl;

  auto it = DAYS.find(day);
  if (it == DAYS.end()) {
    std::cerr << "Day " << day << " not found!" << std::endl;
    return 1;
  }

  double elapsed = run_day_with_timing(it->second);

  print_timing(elapsed);
  std::cout << std::endl;

  return elapsed;
}

void print_summary(std::vector<DayResult> results) {
  double total_time = 0.0;
  print_separator();
  std::cout << "\nSummary:" << std::endl;
  for (const auto& result : results) {
    std::cout << "  Day " << std::setw(2) << std::setfill('0') << result.day << std::setfill(' ')
              << ": " << std::setw(10) << std::fixed << std::setprecision(3)
              << result.elapsed_ms << " ms" << std::endl;

    total_time += result.elapsed_ms;
  }

  print_separator(true);
  std::cout << "  Total :" << std::setw(11) << std::fixed << std::setprecision(3)
            << total_time << " ms\n\n";
  print_separator();
}

void run_all() {
  std::vector<DayResult> results;
  for (const auto& [day, run_func] : DAYS) {
    double elapsed = run_single_day(day);
    results.push_back({day, elapsed});
  }

  print_summary(results);
}

int main(int argc, char** argv) {
  print_header();

  if (argc > 1) {
    int day = std::stoi(argv[1]);
    run_single_day(day);
  } else {
    run_all();
  }

  return 0;
}
