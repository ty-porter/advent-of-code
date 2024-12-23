from src.utils.prompt import Prompt

import networkx as nx

def part_1_solution(edges):
    nodes = {}

    for edge in edges:
        n1, n2 = edge.split("-")

        if n1 in nodes:
            if n2 in nodes[n1]:
                continue

            nodes[n1].append(n2)
        else:
            nodes[n1] = [n2]

        if n2 in nodes:
            if n1 in nodes[n2]:
                continue

            nodes[n2].append(n1)
        else:
            nodes[n2] = [n1]

    interconnected = {}

    for n1, a1 in nodes.items():
        for n2 in a1:
            for n3 in nodes[n2]:
                if n1 in nodes[n3]:
                    interconnected[tuple(sorted([n1, n2, n3]))] = "t" in n1[0] + n2[0] + n3[0]

    return sum(interconnected.values())

def part_2_solution(edges):
    graph = nx.Graph()

    for edge in edges:
        n1, n2 = edge.split("-")

        graph.add_edge(n1, n2)

    cliques = list(nx.find_cliques_recursive(graph))
    code = max(cliques, key=len)
    code.sort()

    return ",".join(code)

def transform_prompt():
    return Prompt.read_to_list(__file__)
