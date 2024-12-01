class Prompt:
  def read(solution_path, test=False):
    prompt_file = "test.txt" if test else "prompt.txt"
    f = open(solution_path.replace("solution.py", prompt_file), "r")
    return f.read()

  def read_to_list(solution_path, test=False):
    prompt_file = "test.txt" if test else "prompt.txt"
    f = open(solution_path.replace("solution.py", prompt_file), "r")
    string = f.read()
    array = string.split("\n")

    return array
