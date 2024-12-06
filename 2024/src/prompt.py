class Prompt:
    TEST_FILENAME = "test.txt"
    PROMPT_FILENAME = "prompt.txt"
    SOLUTION_SUFFIX = "solution.py"

    def read(solution_path, test=False):
        return Prompt.file(solution_path, test)

    def read_to_list(solution_path, test=False):
        return Prompt.file(solution_path, test).split("\n")

    def read_to_grid(solution_path, test=False):
        return [[c for c in row] for row in Prompt.file(solution_path, test).split("\n")]

    def file(solution_path, test):
        prompt_file = Prompt.TEST_FILENAME if test else Prompt.PROMPT_FILENAME
        with open(solution_path.replace(Prompt.SOLUTION_SUFFIX, prompt_file), "r") as f:
            return f.read()
