import os, re

max_solution = 0

for solution_dir in os.listdir("src"):
    if not os.path.isdir(f"src/{solution_dir}") or re.match(solution_dir, "\D"):
        continue

    if solution_dir == "__pycache__":
        continue

    if int(solution_dir) > max_solution:
        max_solution = int(solution_dir)

next_dir = max_solution + 1

if next_dir < 10:
    padded_next_dir = f"0{next_dir}"
else:
    padded_next_dir = next_dir

os.system(f"mkdir src/{padded_next_dir}")
os.system(f"touch src/{padded_next_dir}/prompt.txt")
os.system(f"cp _template.py src/{padded_next_dir}/solution.py")