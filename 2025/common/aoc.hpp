#pragma once
#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <charconv>
#include <algorithm>

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

  inline std::string read_file(std::string_view path) {
    std::ifstream prompt{std::string(path)};

    if (!prompt.is_open()) {
      throw std::runtime_error("Unable to open prompt! " + std::string(path));
    }

    std::ostringstream ss;
    ss << prompt.rdbuf();

    return ss.str();
  }

  inline std::vector<std::string_view> split(std::string_view s, char delimiter) {
    std::vector<std::string_view> out;

    while (!s.empty()) {
      auto pos = s.find(delimiter);
      out.push_back(s.substr(0, pos));

      if (pos == std::string_view::npos) {
        break;
      }

      s.remove_prefix(pos + 1);
    }

    return out;
  }

  inline std::string_view trim(std::string_view s) {
    auto start = s.find_first_not_of(" \t\n\r");

    if (start == std::string_view::npos) {
      return "";
    }

    auto end = s.find_last_not_of(" \t\n\r");

    return s.substr(start, end - start + 1);
  }

}
