from src.prompt import Prompt

import json

class FileTree:
  
  def __init__(self, commands):
    self.root = {}             # Start point
    self.dir  = self.root      # Dict for files and child dirs of current directory
    self.path = []             # Dict keys that were traversed to get to current path

    self.commands = commands   # List of commands to traverse
    self.pointer = 0           # Pointer to current command

  def traverse(self):
    command = self.commands[self.pointer]

    if command[0] == "$":
      if command[2:4] == "cd":
        self.cd(command[5:])
      else:
        self.ls()
    else:
      raise Exception("Not a command!")

    if self.pointer >= len(self.commands):
      return self.root
    else:
      self.traverse()

  def cd(self, path):
    # Fall all the way back to root, reset path chain
    if path == "/":
      self.dir = self.root
      self.path = []

    # Fall back to previous directory, pop last value from path
    elif path == "..":
      self.path.pop()

      self.dir = self.root

      for p in self.path:
        self.dir = self.dir[p]

    # Otherwise, move to target dir (creating it if need be)
    else:
      self.path.append(path)

      if path not in self.dir:
        self.dir[path] = {}

      self.dir = self.dir[path]

    self.pointer += 1

  def ls(self):
    # Move ahead one line to parse the lines until the next command is found
    self.pointer += 1

    line = self.next_command()

    while line and line[0] != "$":
      if line[0:3] == "dir":
        _, dirname = line.split(" ")

        if dirname not in self.dir:
          self.dir[dirname] = {}
      else:
        size, filename = line.split(" ")

        self.dir[filename] = int(size)

      self.pointer += 1
      line = self.next_command()

  def next_command(self):
    if self.pointer < len(self.commands):
      return self.commands[self.pointer]

  def dirmap(self):
    return self.dirsizes(self.root)

  def dirsizes(self, directory, path="./", sizes=[]):
    size = 0

    for name in directory:    
      if isinstance(directory[name], dict):
        dirsize, _ = self.dirsizes(directory[name], path + name + "/", sizes)

        size += dirsize
        size_dict = { path + name + "/": dirsize }

        if path + name + "/" not in [list(traversed.keys())[0] for traversed in sizes]:
          sizes.append(size_dict)

      else:
        size += directory[name]

    size_dict = { path: size }

    # Traversed sizes are parsed twice, since one can be added above.
    if path not in [list(traversed.keys())[0] for traversed in sizes]:
      sizes.append(size_dict)

    return [size, sizes]

  def __str__(self):
    return json.dumps(self.root, indent=2)

def part_1_solution(commands):
  tree = FileTree(commands)
  tree.traverse()

  _total_used, sizes = tree.dirmap()

  count = 0

  for size_dict in sizes:
    size = sum(size_dict.values())

    if size < 100_000:
      count += size

  return count

def part_2_solution(commands):
  tree = FileTree(commands)
  tree.traverse()

  total             = 70_000_000
  total_required    = 30_000_000

  total_used, sizes = tree.dirmap()
  total_unused      = total - total_used

  minimum = None

  for size_dict in sizes:
    size = sum(size_dict.values())

    if total_unused + size >= total_required:
      if minimum is None or size < minimum:
        minimum = size

  return minimum

def transform_prompt():
  return Prompt.read_to_list(__file__)
