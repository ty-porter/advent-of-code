#pragma once
#include "../common/aoc.hpp"

namespace day06 {

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
    default:
      throw std::runtime_error("Unknown operator");
  }
}

// Part 1 and 2 solution are identical except for prompt parsing
long solve(
  const std::vector<std::vector<long>>& operands,
  const std::vector<Operator>& operators
) {
  long sum = 0;

  for (size_t i = 0; i < operands.size(); i++) {
    std::vector<long> group = operands[i];
    Operator op = operators[i];

    long acc = op == Operator::MUL ? 1 : 0;
    for (long operand : group) {
      acc = reduce(acc, operand, op);
    }

    sum += acc;
  }

  return sum;
}

void run(const std::string& input_file = "06/prompt.txt") {
  auto lines = AOC::read_lines(input_file);

  std::vector<std::vector<long>> row_operands;
  std::vector<std::vector<long>> col_operands;
  std::vector<Operator> row_operators;
  std::vector<Operator> col_operators;

  // Operators
  for (auto operand : AOC::split(lines.back(), ' ')) {
      std::string o = std::string(AOC::trim(operand));
      if (o.size() == 0) continue;

      Operator op = static_cast<Operator>(o[0]);;
      row_operators.push_back(op);
      col_operators.emplace(col_operators.begin(), op);
  }

  // Allocate the operand vectors
  row_operands.resize(row_operators.size());
  col_operands.resize(col_operators.size());

  // Row operands
  for (size_t i = 0; i < lines.size() - 1; i++) {
    std::string line = lines[i];
    std::vector<std::string_view> operands = AOC::split(line, ' ');

    size_t col = 0;
    for (size_t j = 0; j < operands.size(); j++) {
      std::string o = std::string(AOC::trim(operands[j]));
      if (o.size() == 0) continue;

      row_operands[col].push_back(std::stol(o));
      col++;
    }
  }

  // Column operands
  size_t col = 0;
  for (int i = lines[0].length() - 1; i >= 0; i--) {
    std::string operand = "";

    for (size_t j = 0; j < lines.size() - 1; j++) {
      char c = lines[j][i];
      if (c == ' ') continue;

      operand += c;
    }

    // Hit a delimiter, ready for next group
    if (operand.size() == 0) {
      col++;
      continue;
    }

    col_operands[col].push_back(std::stol(operand));
  }

  long p1_result = solve(row_operands, row_operators);
  std::cout << "Part 1: " << p1_result << std::endl;

  long p2_result = solve(col_operands, col_operators);
  std::cout << "Part 2: " << p2_result << std::endl;
}

} // namespace day06
