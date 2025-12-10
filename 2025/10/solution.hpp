#pragma once
#include "../common/aoc.hpp"

namespace day10 {

struct Machine {
  uint target;
  size_t sz;
  std::vector<uint> buttons;
  // TODO: joltages

  friend std::ostream& operator<<(std::ostream& os, const Machine& m) {
    os << "Machine{target: " << m.target << ", sz: " << m.sz  << ", btn_cnt: " << m.buttons.size() << '}';
    return os;
  }
};

struct MachineState {
  uint cost;
  uint state;
  uint prev_button;

  bool operator<(const MachineState& rhs) const { return cost < rhs.cost; }
  bool operator>(const MachineState& rhs) const { return cost > rhs.cost; }
  bool operator==(const MachineState& rhs) const { return cost == rhs.cost && state == rhs.state; }

  friend std::ostream& operator<<(std::ostream& os, const MachineState& ms) {
    os << "MachineState{cost: " << ms.cost << ", state: " << ms.state  << ", prev: " << ms.prev_button << '}';
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

size_t bfs_shortest_path(Machine machine) {
  MachineState start = { 0, 0, 0 };
  std::priority_queue<MachineState, std::vector<MachineState>, std::greater<MachineState>> pqueue;
  pqueue.push(start);
  std::set<uint> seen;

  while (!pqueue.empty()) {
    MachineState machine_state = pqueue.top();
    pqueue.pop();

    if (machine_state.state == machine.target) return machine_state.cost;
    if (seen.find(machine_state.state) != seen.end()) continue;

    seen.insert(machine_state.state);

    for (auto b : machine.buttons) {
      if (machine_state.prev_button == b) continue;

      MachineState next_state = {
        machine_state.cost + 1,
        machine_state.state ^ b,
        b
      };

      pqueue.push(next_state);
    }

    if (machine_state.cost > 1000) break;
  }

  return -1;
}

long part1(const std::vector<Machine>& machines) {
  long min_cost = 0;

  for (Machine machine : machines) {
    min_cost += bfs_shortest_path(machine);
  }

  return min_cost;
}

long part2(const std::vector<std::string>& lines) {
  UNUSED(lines);

  return 0;
}

void run(const std::string& input_file = "10/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::vector<Machine> machines;

  for (auto line : lines) {
    std::vector<std::string_view> parts = AOC::split(line, ' ');

    uint indicator = parse_indicator(parts[0]);
    std::vector<uint> buttons = parse_buttons(std::vector<std::string_view>(parts.begin() + 1, parts.end() - 1));
    std::string joltages = std::string(parts[parts.size() - 1]); // TODO

    machines.push_back({ indicator, parts[0].size() - 2, buttons });
  }

  long p1_result = part1(machines);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = part2(lines);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day10
