from src.utils.prompt import Prompt


def is_valid(pageset, rules):
    seen = {}

    for i, page in enumerate(pageset):
        seen[page] = i

        if page in rules:
            for pagerule in rules[page]:
                if pagerule in seen:
                    return (False, i, seen[pagerule])

    return (True, None, None)


def swap(pageset, i, j):
    tmp = pageset[i]
    pageset[i] = pageset[j]
    pageset[j] = tmp

    return pageset


def make_valid(pageset, rules):
    valid, i, j = is_valid(pageset, rules)

    if valid:
        return pageset

    return make_valid(swap(pageset, i, j), rules)


def score(pageset):
    return pageset[len(pageset) // 2]


def part_1_solution(args):
    rules, pagesets = args

    return sum(score(pageset) for pageset in pagesets if is_valid(pageset, rules)[0])


def part_2_solution(args):
    rules, pagesets = args

    return sum(
        score(make_valid(pageset, rules))
        for pageset in pagesets
        if not is_valid(pageset, rules)[0]
    )


def transform_prompt():
    rule_section, page_section = [
        section.split("\n") for section in Prompt.read(__file__).split("\n\n")
    ]

    ruleset = [tuple(int(part) for part in rule.split("|")) for rule in rule_section]
    pages = [[int(part) for part in page.split(",")] for page in page_section]

    rules = {}

    for rule in ruleset:
        if rule[0] in rules:
            rules[rule[0]].append(rule[1])
        else:
            rules[rule[0]] = [rule[1]]

    return rules, pages
