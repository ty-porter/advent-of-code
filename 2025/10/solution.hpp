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

  friend std::ostream& operator<<(std::ostream& os, const MachineIndicatorState& ms) {
    os << "MachineIndicatorState{cost: " << ms.cost << ", state: " << ms.state  << ", prev: " << ms.prev_button << '}';
    return os;
  }
};

struct MachineJoltageState {
  uint cost;
  std::vector<uint> state;

  bool operator<(const MachineJoltageState& rhs) const { return cost < rhs.cost; }
  bool operator>(const MachineJoltageState& rhs) const { return cost > rhs.cost; }
  bool operator==(const MachineJoltageState& rhs) const { return cost == rhs.cost && state == rhs.state; }

  friend std::ostream& operator<<(std::ostream& os, const MachineJoltageState& ms) {
    std::stringstream ss;
    ss << '{';
    for (size_t i = 0; i < ms.state.size(); i++) {
        ss << ms.state[i];
        if (i < ms.state.size() - 1) ss << ", ";
    }
    ss << '}';

    os << "MachineJoltageState{cost: " << ms.cost << ", state: " << ss.str()  << '}';
    return os;
  }
};

struct Machine {
  uint target;
  size_t sz;
  std::vector<uint> buttons;
  std::vector<uint> joltages;

  long joltage_distance(const MachineJoltageState& mjs) {
    long sum = 0;

    for (size_t i = 0; i < joltages.size(); i++) {
      if (joltages[i] < mjs.state[i]) return -1; // Can never hit

      sum += joltages[i] - mjs.state[i];
    }

    return sum;
  }

  friend std::ostream& operator<<(std::ostream& os, const Machine& m) {
    std::stringstream ss;
    ss << '{';
    for (size_t i = 0; i < m.joltages.size(); i++) {
        ss << m.joltages[i];
        if (i < m.joltages.size() - 1) ss << ", ";
    }
    ss << '}';
    os << "Machine{target: " << m.target << ", sz: " << m.sz  << ", btn_cnt: " << m.buttons.size() << ", joltage: " << ss.str() << '}';
    return os;
  }
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
  
  // for (int i = values.size() - 1; i >= 0; i--) {
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

long bfs_shortest_path_by_joltage(Machine machine) {
  std::vector<uint> zero_joltages;

  for (size_t i = 0; i < machine.joltages.size(); i++) zero_joltages.push_back(0);

  MachineJoltageState start = { 0, zero_joltages };
  std::priority_queue<MachineJoltageState, std::vector<MachineJoltageState>, std::greater<MachineJoltageState>> pqueue;
  pqueue.push(start);
  std::set<std::vector<uint>> seen;

  while (!pqueue.empty()) {
    MachineJoltageState machine_state = pqueue.top();
    pqueue.pop();

    if (machine.joltage_distance(machine_state) == 0) return static_cast<long>(machine_state.cost);
    if (seen.find(machine_state.state) != seen.end()) continue;
    seen.insert(machine_state.state);

    if (machine.joltage_distance(machine_state) < 0) continue;

    for (auto b : machine.buttons) {
      std::vector<uint> new_joltages = std::vector<uint>(machine_state.state.begin(), machine_state.state.end());

      size_t i = 0;
      while (b) {
        if (b & 1) new_joltages[i] += 1;
        b >>= 1;
        i++;
      }

      MachineJoltageState next_state = {
        machine_state.cost + 1,
        new_joltages
      };

      pqueue.push(next_state);
    }
  }

  return -1;
}

long part1(const std::vector<Machine>& machines) {
  long min_cost = 0;

  for (Machine machine : machines) {
    min_cost += bfs_shortest_path_by_indicator(machine);
  }

  return min_cost;
}

long part2(const std::vector<Machine>& machines) {
  long min_cost = 0;

  for (size_t i = 0; i < machines.size(); i++) {
    Machine machine = machines[i];
    min_cost += bfs_shortest_path_by_joltage(machine);

    std::cout << "Completed " << i + 1 << " of " << machines.size() << std::endl;
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
