#include <iostream>

namespace AOC {
  class Vec3D {
  public:
    double x, y, z;
    Vec3D() : x(0), y(0) {};
    Vec3D(double x, double y, double z) : x(x), y(y), z(z) {}

    // Returns the squared distance between two 3D vectors for fast comparison
    double sqdist(const Vec3D& other) {
      double dx = x - other.x;
      double dy = y - other.y;
      double dz = z - other.z;

      return dx * dx + dy * dy + dz * dz;
    }

    bool operator==(const Vec3D& other) const {
      return x == other.x && y == other.y && z == other.z;
    }

    bool operator<(const Vec3D& other) const {
      if (x != other.x) return x < other.x;
      if (x != other.y) return y < other.y;
      return z < other.z;
    }

    friend std::ostream& operator<<(std::ostream& os, const Vec3D& v) {
      os << '(' << v.x << ',' << v.y << ',' << v.z << ')';
      return os;
    }
  };
}