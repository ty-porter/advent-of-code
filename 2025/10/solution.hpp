#pragma once
#include "../common/aoc.hpp"

namespace day10 {

struct MachineIndicatorState {
  uint cost;
  uint state;
  uint prev_button;

  bool operator<(const MachineIndicatorState& rhs) const { return cost < rhs.cost; }
  bool operator>(const MachineIndicatorState& rhs) const { return cost > rhs.cost; }
  bool operator==(const MachineIndicatorState& rhs) const { return cost == rhs.cost && state == rhs.state; }
};

struct Machine {
  uint target;
  size_t sz;
  std::vector<uint> buttons;
  std::vector<uint> joltages;
};

uint parse_indicator(const std::string_view& indicator) {
  uint ind = 0;
  size_t start = 1;

  for (size_t i = start; i < indicator.size() - 1; i++) {
    char c = indicator[i];

    if (c == '#') ind |= 1 << (i - start);
  }

  return ind;
}

std::vector<uint> parse_buttons(const std::vector<std::string_view>& _buttons) {
  std::vector<uint> parsed_buttons;

  for (auto _button : _buttons) {
    const std::string button = static_cast<std::string>(_button).substr(1, _button.length() - 2);
    std::vector<std::string_view> lights = AOC::split(button, ',');

    uint b = 0;
    for (auto light : lights) {
      b |= (1 << std::stoi(static_cast<std::string>(light)));
    }

    parsed_buttons.push_back(b);
  }

  return parsed_buttons;
}

std::vector<uint> parse_joltages(const std::string_view _joltages) {
  std::vector<uint> parsed_joltages;

  const std::string joltage = static_cast<std::string>(_joltages).substr(1, _joltages.length() - 2);
  std::vector<std::string_view> values = AOC::split(joltage, ',');

  for (auto value : values) {
    uint j = 0;
    j = std::stoi(static_cast<std::string>(value));
    parsed_joltages.push_back(j);
  }

  return parsed_joltages;
}

long bfs_shortest_path_by_indicator(Machine machine) {
  MachineIndicatorState start = { 0, 0, 0 };
  std::priority_queue<MachineIndicatorState, std::vector<MachineIndicatorState>, std::greater<MachineIndicatorState>> pqueue;
  pqueue.push(start);
  std::set<uint> seen;

  while (!pqueue.empty()) {
    MachineIndicatorState machine_state = pqueue.top();
    pqueue.pop();

    if (machine_state.state == machine.target) return static_cast<long>(machine_state.cost);
    if (seen.find(machine_state.state) != seen.end()) continue;

    seen.insert(machine_state.state);

    for (auto b : machine.buttons) {
      if (machine_state.prev_button == b) continue;

      MachineIndicatorState next_state = {
        machine_state.cost + 1,
        machine_state.state ^ b,
        b
      };

      pqueue.push(next_state);
    }
  }

  return -1;
}

// Convert button index to coefficient vector
std::vector<int> button_to_coeffs(uint button, size_t num_vars) {
  std::vector<int> coeffs(num_vars, 0);
  for (size_t i = 0; i < num_vars; i++) {
    if (button & (1 << i)) {
      coeffs[i] = 1;
    }
  }
  return coeffs;
}

std::map<std::vector<int>, int> generate_patterns(const std::vector<std::vector<int>>& coeffs) {
  std::map<std::vector<int>, int> pattern_costs;
  size_t num_buttons = coeffs.size();
  size_t num_variables = coeffs[0].size();

  for (int pattern_len = 0; pattern_len <= static_cast<int>(num_buttons); pattern_len++) {
    std::vector<int> indices(num_buttons);
    for (size_t i = 0; i < num_buttons; i++) indices[i] = i;

    for (int mask = 0; mask < (1 << num_buttons); mask++) {
      if (__builtin_popcount(mask) != pattern_len) continue;

      std::vector<int> pattern(num_variables, 0);
      for (size_t i = 0; i < num_buttons; i++) {
        if (mask & (1 << i)) {
          for (size_t j = 0; j < num_variables; j++) {
            pattern[j] += coeffs[i][j];
          }
        }
      }

      if (pattern_costs.find(pattern) == pattern_costs.end()) {
        pattern_costs[pattern] = pattern_len;
      }
    }
  }

  return pattern_costs;
}

long solve_single_machine(const std::vector<std::vector<int>>& coeffs, const std::vector<int>& goal) {
  auto pattern_costs = generate_patterns(coeffs);

  std::map<std::vector<int>, long> cache;

  std::function<long(const std::vector<int>&)> solve_aux = [&](const std::vector<int>& current_goal) -> long {
    bool all_zero = true;
    for (int val : current_goal) {
      if (val != 0) {
        all_zero = false;
        break;
      }
    }
    if (all_zero) return 0;

    if (cache.find(current_goal) != cache.end()) {
      return cache[current_goal];
    }

    long answer = 1000000;

    for (const auto& [pattern, pattern_cost] : pattern_costs) {
      bool can_apply = true;
      for (size_t i = 0; i < pattern.size(); i++) {
        if (pattern[i] > current_goal[i] || (pattern[i] % 2) != (current_goal[i] % 2)) {
          can_apply = false;
          break;
        }
      }

      if (can_apply) {
        std::vector<int> new_goal(pattern.size());
        for (size_t i = 0; i < pattern.size(); i++) {
          new_goal[i] = (current_goal[i] - pattern[i]) / 2;
        }

        long sub_answer = solve_aux(new_goal);
        answer = std::min(answer, static_cast<long>(pattern_cost) + 2 * sub_answer);
      }
    }

    cache[current_goal] = answer;
    return answer;
  };

  return solve_aux(goal);
}

long part1(const std::vector<Machine>& machines) {
  long min_cost = 0;

  for (Machine machine : machines) {
    min_cost += bfs_shortest_path_by_indicator(machine);
  }

  return min_cost;
}

long part2(const std::vector<Machine>& machines) {
  /*
    Solution inspired by https://www.reddit.com/r/adventofcode/comments/1pk87hl/2025_day_10_part_2_bifurcate_your_way_to_victory/
    Not sure I would have solved this without it.
  */
  long min_cost = 0;

  for (auto machine : machines) {
    std::vector<std::vector<int>> coeffs;
    for (auto button : machine.buttons) {
      coeffs.push_back(button_to_coeffs(button, machine.joltages.size()));
    }

    std::vector<int> goal;
    for (auto joltage : machine.joltages) {
      goal.push_back(static_cast<int>(joltage));
    }

    min_cost += solve_single_machine(coeffs, goal);
  }

  return min_cost;
}

void run(const std::string& input_file = "10/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::vector<Machine> machines;

  for (auto line : lines) {
    std::vector<std::string_view> parts = AOC::split(line, ' ');

    uint indicator = parse_indicator(parts[0]);
    std::vector<uint> buttons = parse_buttons(std::vector<std::string_view>(parts.begin() + 1, parts.end() - 1));
    std::vector<uint> joltages = parse_joltages(parts[parts.size() - 1]);

    machines.push_back({ indicator, parts[0].size() - 2, buttons, joltages });
  }

  long p1_result = part1(machines);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(machines);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day10
