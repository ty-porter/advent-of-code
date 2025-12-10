#include <iostream>

namespace AOC {
  class Vec2D {
  public:
    double x, y;
    Vec2D() : x(0), y(0) {};
    Vec2D(double x, double y) : x(x), y(y) {}

    static const AOC::Vec2D UP()        { return AOC::Vec2D {  0, -1 }; }
    static const AOC::Vec2D DOWN()      { return AOC::Vec2D {  0,  1 }; }
    static const AOC::Vec2D LEFT()      { return AOC::Vec2D { -1,  0 }; }
    static const AOC::Vec2D RIGHT()     { return AOC::Vec2D {  1,  0 }; }

    static const AOC::Vec2D UPLEFT()    { return AOC::Vec2D { -1, -1 }; }
    static const AOC::Vec2D UPRIGHT()   { return AOC::Vec2D {  1, -1 }; }
    static const AOC::Vec2D DOWNLEFT()  { return AOC::Vec2D { -1,  1 }; }
    static const AOC::Vec2D DOWNRIGHT() { return AOC::Vec2D {  1,  1 }; }

    static Vec2D add(const Vec2D& lhs, const Vec2D& rhs) {
      return Vec2D(lhs.x + rhs.x, lhs.y + rhs.y);
    }

    static Vec2D sub(const Vec2D& lhs, const Vec2D& rhs) {
      return Vec2D(lhs.x - rhs.x, lhs.y - rhs.y);
    }

    bool operator==(const Vec2D& other) const {
      return x == other.x && y == other.y;
    }

    bool operator<(const Vec2D& other) const {
      if (x != other.x) return x < other.x;
      return y < other.y;
    }

    friend std::ostream& operator<<(std::ostream& os, const Vec2D& v) {
      os << '(' << v.x << ',' << v.y << ')';
      return os;
    }
  };

  class Box2D {
    Vec2D min, max;
  public:
    Box2D(Vec2D v1, Vec2D v2) {
      min = Vec2D(
        std::min(v1.x, v2.x),
        std::min(v1.y, v2.y)
      );
      max = Vec2D(
        std::max(v1.x, v2.x),
        std::max(v1.y, v2.y)
      );
    }

    Vec2D getMin() const { return min; }
    Vec2D getMax() const { return max; }

    double area() {
      double dx = max.x - min.x + 1;
      double dy = max.y - min.y + 1;
      return dx * dy;
    }

    friend std::ostream& operator<<(std::ostream& os, const Box2D& b) {
      os << '[' << b.min << ',' << b.max << ']';
      return os;
    }
  };
}