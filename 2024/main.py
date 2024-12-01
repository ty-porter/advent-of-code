import argparse, copy, importlib, os

from src.utils import Color, colorize

parser = argparse.ArgumentParser(prog = "Advent of Code 2022")
parser.add_argument("solution", type=int, nargs="?")

args = parser.parse_args()

solution_dirs = []

if args.solution:
    solution_dir = f"0{str(args.solution)}" if args.solution < 10 else str(args.solution)

    if os.path.exists(f"src/{solution_dir}"):
        solution_dirs.append(f"src/{solution_dir}")
    else:
        raise Exception(f"Solution directory 'src/{solution_dir}' does not exist!")
else:
    for solution_dir in sorted(os.listdir("src")):
        if os.path.isdir(f"src/{solution_dir}") and solution_dir != "__pycache__":
            solution_dirs.append(f"src/{solution_dir}")

print(colorize("Printing Advent of Code solutions for 2022!", Color.YELLOW))

for index, solution_dir in enumerate(solution_dirs):
    solution_package = solution_dir.replace("/", ".") + ".solution"
    solution_runner = importlib.import_module(solution_package)

    values = solution_runner.transform_prompt()

    indent = " " * 2
    
    if index > 0:
        print()

    day = str(int(solution_dir.split("/")[-1]))

    print(indent + colorize(f"- DAY {day}", Color.CYAN))

    print(indent * 3 + "Part 1: " + colorize(solution_runner.part_1_solution(copy.deepcopy(values)), Color.YELLOW))
    print(indent * 3 + "Part 2: " + colorize(solution_runner.part_2_solution(copy.deepcopy(values)), Color.YELLOW))
