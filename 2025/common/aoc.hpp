#pragma once
#include <iostream>
#include <string>
#include <string_view>
#include <vector>
#include <set>
#include <fstream>
#include <sstream>
#include <stdexcept>
#include <charconv>
#include <algorithm>

#define UNUSED(x) ((void)(x))

namespace AOC {

  class Vec2 {
  public:
    double x;
    double y;
    Vec2() : x(0), y(0) {};
    Vec2(double x, double y) {
      this->x = x;
      this->y = y;
    }

    static const AOC::Vec2 UP()        { return AOC::Vec2 {  0, -1 }; }
    static const AOC::Vec2 DOWN()      { return AOC::Vec2 {  0,  1 }; }
    static const AOC::Vec2 LEFT()      { return AOC::Vec2 { -1,  0 }; }
    static const AOC::Vec2 RIGHT()     { return AOC::Vec2 {  1,  0 }; }

    static const AOC::Vec2 UPLEFT()    { return AOC::Vec2 { -1, -1 }; }
    static const AOC::Vec2 UPRIGHT()   { return AOC::Vec2 {  1, -1 }; }
    static const AOC::Vec2 DOWNLEFT()  { return AOC::Vec2 { -1,  1 }; }
    static const AOC::Vec2 DOWNRIGHT() { return AOC::Vec2 {  1,  1 }; }

    bool operator==(const Vec2& other) const {
      return x == other.x && y == other.y;
    }

    bool operator<(const Vec2& other) const {
      if (x != other.x) return x < other.x;
      return y < other.y;
    }

    friend std::ostream& operator<<(std::ostream& os, const Vec2& v2) {
      os << '(' << v2.x << ',' << v2.y << ')';
      return os;
    }
    
    Vec2 add(const Vec2& other) {
      return Vec2(x + other.x, y + other.y);
    }
  };

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

    if (out.empty()) out.push_back(s);

    return out;
  }

  inline std::vector<std::string_view> substring_split(std::string_view s, const std::string_view delimiter) {
    std::vector<std::string_view> out;

    while (!s.empty()) {
      auto pos = s.find(delimiter);
      out.push_back(s.substr(0, pos));

      if (pos == std::string_view::npos) {
        break;
      }

      s.remove_prefix(pos + delimiter.length());
    }

    if (out.empty()) out.push_back(s);

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
