from src.utils.prompt import Prompt


def part_1_solution(lists):
    list1, list2 = lists

    list1.sort()
    list2.sort()

    return sum(abs(list1[i] - list2[i]) for i in range(len(list1)))


def part_2_solution(lists):
    list1, list2 = lists

    return sum(list1[i] * list2.count(list1[i]) for i in range(len(list1)))


def transform_prompt():
    list1 = []
    list2 = []

    for line in Prompt.read_to_list(__file__):
        list1.append(int(line[0:5]))
        list2.append(int(line[8:13]))

    return (list1, list2)
