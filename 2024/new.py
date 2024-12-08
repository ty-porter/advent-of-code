import os, re

SOURCE_DIRECTORY = "src"
SOLUTION_TEMPLATE = "_template.py"
SOLUTION_NAME = "solution.py"
PROMPT_NAME = "prompt.txt"

max_solution = 0

for solution_dir in os.listdir(SOURCE_DIRECTORY):
    if not os.path.isdir(f"{SOURCE_DIRECTORY}/{solution_dir}") or re.match(solution_dir, "\D"):
        continue

    if solution_dir == "__pycache__":
        continue

    if int(solution_dir) > max_solution:
        max_solution = int(solution_dir)

next_dir = str(max_solution + 1)

solution_dir = os.path.join(SOURCE_DIRECTORY, next_dir.rjust(2, "0"))

os.mkdir(solution_dir)

with open(SOLUTION_TEMPLATE, "rb") as template:
    with open(os.path.join(solution_dir, SOLUTION_NAME), "wb") as solution:
        solution.write(template.read())

with open(os.path.join(solution_dir, PROMPT_NAME), "wb"):
    pass
