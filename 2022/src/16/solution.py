from src.prompt import Prompt

import re

def find_distances(valves):
  key_valves = set()
  distances  = {} 

  for valve in valves:
    rate, _ = valves[valve]

    if rate > 0 or valve == "AA":
      key_valves.add(valve)

    current, incoming, distance = set([valve]), set(), 0
    distances[(valve, valve)] = 0

    while current:
      distance += 1
      for position in current:
        for adjacent in valves[position][-1]:
          if (valve, adjacent) not in distances:
            distances[(valve, adjacent)] = distance
            incoming.add(adjacent)

      current, incoming = incoming, set()

  return distances, key_valves

def part_1_solution(valves):
  distances, key_valves = find_distances(valves)

  def search(current="AA", time=30, seen=set(), targets=key_valves):
    seen = seen | {current}
    targets = targets - seen

    max_flow = 0
    for target in targets:
      time_remaining = time - distances[(current, target)] - 1
      if time_remaining > 0:
        flow = valves[target][0] * time_remaining
        flow += search(target, time_remaining, seen, targets)
        if flow > max_flow:
          max_flow = flow

    return max_flow

  return search()

def part_2_solution(valves):
  distances, key_valves = find_distances(valves)

  endpoints = {}
  def search(current="AA", current_flow=0, time=26, seen=set()):
    seen = seen | {current}
    targets = key_valves - seen

    endpoint = frozenset(seen - {"AA"})

    if endpoint in endpoints:
      endpoints[endpoint] = max(endpoints[endpoint], current_flow)
    else:
      endpoints[endpoint] = current_flow

    max_flow = 0
    for target in targets:
      time_remaining = time - distances[(current, target)] - 1
      if time_remaining > 0:
        flow = valves[target][0] * time_remaining
        flow += search(target, current_flow + flow, time_remaining, seen)
        if flow > max_flow:
          max_flow = flow

    return max_flow

  def search_endpoints(current=frozenset(key_valves - {"AA"})):
    if current not in endpoints:
      max_flow = 0
      for point in current:
        subset = current - {point}
        flow = search_endpoints(subset)
        if flow > max_flow:
          max_flow = flow
        
      endpoints[current] = max_flow

    return endpoints[current]

  search()
  search_endpoints()

  max_flow = 0
  for human in endpoints:
    elephant = frozenset(key_valves - {"AA"} - human)
    total_flow = endpoints[human] + endpoints[elephant]

    if total_flow > max_flow:
      max_flow = total_flow
  
  return max_flow

def transform_prompt():
  valves = {}

  for line in Prompt.read_to_list(__file__):
    match = re.match(r"Valve (?P<valve>.+) has flow rate=(?P<rate>.+); tunnels? leads? to valves? (?P<connected>.+)", line)

    valve = match.group("valve")
    rate = int(match.group("rate"))
    connected = match.group("connected").split(", ")

    valves[valve] = (rate, connected)

  return valves
