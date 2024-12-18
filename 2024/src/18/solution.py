from src.utils.prompt import Prompt
from src.utils.plane import Position2D

from dataclasses import dataclass, field
from queue import PriorityQueue


@dataclass(order=True)
class SearchEntry:
    steps: int
    position: Position2D = field(compare=False)

def shortest_path(X, Y, BYTES, BYTE_MAX):
    START = Position2D(0, 0)
    FINISH = Position2D(X, Y)

    pq = PriorityQueue()
    pq.put(SearchEntry(0, START))

    visited = {}

    while not pq.empty():
        entry = pq.get()

        if entry.position == FINISH:
            return entry.steps
        
        for neighbor in entry.position.cardinal_neighbors():
            if neighbor.x < 0 or neighbor.x > X or neighbor.y < 0 or neighbor.y > Y:
                    continue

            if neighbor in BYTES:
                if BYTES[neighbor] <= BYTE_MAX:
                    continue

            if neighbor not in visited or entry.steps + 1 < visited[neighbor]:
                visited[neighbor] = entry.steps + 1
                pq.put(SearchEntry(entry.steps + 1, neighbor))

    return -1

def part_1_solution(BYTES):
    return shortest_path(70, 70, BYTES, 1024)

def part_2_solution(BYTES):
    lo, hi = (1025, len(BYTES))

    while lo != hi:
        mid = (lo + hi) // 2

        if shortest_path(70, 70, BYTES, mid) != -1:
            lo = mid + 1
        else:
            hi = mid

    return Prompt.read_to_list(__file__)[lo - 1]

def transform_prompt():
    BYTES = {}
    for ns, line in enumerate(Prompt.read_to_list(__file__)):
        x, y = line.split(",")

        BYTES[Position2D(int(x), int(y))] = ns + 1

    return BYTES
