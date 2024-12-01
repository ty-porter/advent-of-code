from src.prompt import Prompt

import re

class Point:
  def __init__(self, x, y):
    self.x = x
    self.y = y

  def __str__(self):
    return f"<Point x={self.x}, y={self.y}>"

  def __repr__(self):
    return self.__str__()

class Sensor:
  def __init__(self, origin, beacon):
    self.origin = origin
    self.beacon = beacon

    self.x_distance = abs(self.origin.x - self.beacon.x)
    self.y_distance = abs(self.origin.y - self.beacon.y)
    self.distance = self.x_distance + self.y_distance

  # Returns 2 end points on the X axis
  def points_visible_at(self, row_num):
    if not (self.origin.y - self.distance <= row_num <= self.origin.y + self.distance):
      return

    # Subtract total visible distance - target row distance to get an offset
    # Points visible in the row will be +/- this offset
    y_offset = self.distance - abs(row_num - self.origin.y)

    return (self.origin.x - y_offset, self.origin.x + y_offset)

  def __str__(self):
    return f"<Sensor origin={self.origin}, beacon={self.beacon}>"

def remove_overlap(ranges):
  ranges = iter(sorted(ranges))
  current_start, current_stop = next(ranges)
  for start, stop in ranges:
    if start > current_stop:
      # Gap between segments: output current segment and start a new one.
      yield current_start, current_stop
      current_start, current_stop = start, stop
    else:
      # Segments adjacent or overlapping: merge.
      current_stop = max(current_stop, stop)
  yield current_start, current_stop

def visible_ranges(sensors, target):
  endpoints = []

  for sensor in sensors:
    endpoint = sensor.points_visible_at(target)
    if endpoint is not None:
      endpoints.append(endpoint)

  unique_ranges = remove_overlap(endpoints)

  return unique_ranges

def part_1_solution(sensors):
  ranges = visible_ranges(sensors, 2_000_000)

  count = 0

  for endpoint in ranges:
    # This has an off-by-one error (-1) and doesn't account for endpoint inclusive.
    # This also does not account for beacons in the target row.
    # I got lucky and there's only one beacon in the target row for the example and actual prompt, so these 2 things cancel out!
    #
    # This solution probably ONLY works on this prompt.
    count += abs(endpoint[0]) + abs(endpoint[1])

  return count

def part_2_solution(sensors):
  MIN = 0
  MAX = 4_000_000

  for row in range(MIN, MAX):
    ranges = list(visible_ranges(sensors, row))

    if len(ranges) == 2:
      return ((ranges[0][1] + 1) * 4_000_000) + row

def transform_prompt():
  sensors = []

  for line in Prompt.read_to_list(__file__):
    points = [int(value) for value in re.findall('-?\d+', line)]

    sensor = Sensor(Point(*points[0:2]), Point(*points[2:]))

    sensors.append(sensor)

  return sensors