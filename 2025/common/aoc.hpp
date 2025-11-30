#pragma once
#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <fstream>
#include <sstream>
#include <stdexcept>
// #include <charconv>

#define UNUSED(x) ((void)(x))

namespace AOC {

  inline std::vector<std::string> read_lines(std::string_view path) {
    std::ifstream prompt{std::string(path)};

    if (!prompt.is_open()) {
      throw std::runtime_error("Unable to open prompt! " + std::string(path));
    }

    std::vector<std::string> out;
    std::string line;
    while (std::getline(prompt, line)) out.push_back(line);

    return out;
  }

  inline std::vector<std::string_view> split(std::string_view s, char delimiter) {
    UNUSED(s); UNUSED(delimiter);
    std::vector<std::string_view> out;

    return out;
  }

}
