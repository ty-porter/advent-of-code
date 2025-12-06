#include "../common/aoc.hpp"

enum Operator {
  ADD = '+',
  MUL = '*'
};

long reduce(long accumulator, long value, Operator op) {
  switch(op) {
    case Operator::ADD:
      return accumulator + value;
    case Operator::MUL:
      return accumulator * value;
  }
}

long part1(
  const std::vector<std::vector<long>>& operands,
  const std::vector<Operator>& operators
) {
  long sum = 0;

  for (size_t x = 0; x < operands[0].size(); x++) {
    Operator op = operators[x];

    long acc = op == Operator::MUL ? 1 : 0;
    for (size_t y = 0; y < operands.size(); y++) {
      acc = reduce(acc, operands[y][x], op);
    }

    sum += acc;
  }

  return sum;
}

long part2(
  const std::vector<std::vector<long>>& operands,
  const std::vector<Operator>& operators
) {
  return 0;
}

int main(int argc, char** argv) {
  std::string input_file = argc > 1 ? argv[1] : "prompt.txt";
  auto lines = AOC::read_lines(input_file);

  std::vector<std::vector<long>> operands;
  std::vector<Operator> operators;

  for (size_t i = 0; i < lines.size(); i++) {
    if (i < lines.size() - 1) operands.push_back({});

    for (auto operand : AOC::split(lines[i], ' ')) {
      std::string o = std::string(AOC::trim(operand));
      if (o.size() == 0) continue;

      if (i < lines.size() - 1) {
        operands[i].push_back(std::stol(o));
      }
      else {
        Operator op = static_cast<Operator>(o[0]);;
        operators.push_back(op);
      }
    }
  }
  


  long p1_result = part1(operands, operators);
  long p2_result = part2(operands, operators);

  std::cout << "Part 1: " << p1_result << std::endl;
  std::cout << "Part 2: " << p2_result << std::endl;
}
