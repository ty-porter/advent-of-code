from src.utils.prompt import Prompt

import math


class CPU:
    def __init__(self, inst, reg_a=0, reg_b=0, reg_c=0):
        # instruction pointer
        self.ip = 0

        # instructions
        self.inst = inst

        # registers
        self.reg_a = reg_a
        self.reg_b = reg_b
        self.reg_c = reg_c

        # jump table
        self._ops = {
            0: self._adv,
            1: self._bxl,
            2: self._bst,
            3: self._jnz,
            4: self._bxc,
            5: self._out,
            6: self._bdv,
            7: self._cdv,
        }

        # output
        self.stdout = []

    def inc_ip(fn):
        def wrapper(self, op):
            fn(self, op)
            self.ip += 2

        return wrapper

    def combo_operand(fn):
        def wrapper(self, op):
            if op < 0 or op > 6:
                raise RuntimeError(f"OOB combo operator: {op}")

            op = [0, 1, 2, 3, self.reg_a, self.reg_b, self.reg_c][op]

            fn(self, op)

        return wrapper

    def run(self):
        while self.ip >= 0 and self.ip < len(self.inst) - 1:
            self._ops[self.inst[self.ip]](self.inst[self.ip + 1])

    def dump(self):
        print("=== REGISTERS ===")
        print("\tA\t", self.reg_a)
        print("\tB\t", self.reg_b)
        print("\tC\t", self.reg_c)

        print()

        print("=== STDOUT ===")
        print(",".join([str(i) for i in self.stdout]))

    # opcode 0
    @inc_ip
    @combo_operand
    def _adv(self, c_op):
        self.reg_a //= int(math.pow(2, c_op))

    # opcode 1
    @inc_ip
    def _bxl(self, l_op):
        self.reg_b ^= l_op

    # opcode 2
    @inc_ip
    @combo_operand
    def _bst(self, c_op):
        self.reg_b = c_op % 8

    # opcode 3
    def _jnz(self, l_op):
        if self.reg_a == 0:
            self.ip += 2

            return

        self.ip = l_op

    # opcode 4
    @inc_ip
    def _bxc(self, _legacy):
        self.reg_b ^= self.reg_c

    # opcode 5
    @inc_ip
    @combo_operand
    def _out(self, c_op):
        self.stdout.append(c_op % 8)

    # opcode 6
    @inc_ip
    @combo_operand
    def _bdv(self, c_op):
        self.reg_b = self.reg_a // int(math.pow(2, c_op))

    # opcode 7
    @inc_ip
    @combo_operand
    def _cdv(self, c_op):
        self.reg_c = self.reg_a // int(math.pow(2, c_op))


def part_1_solution(cpu):
    cpu.run()

    return ",".join([str(i) for i in cpu.stdout])


def part_2_solution(values):
    return


def transform_prompt():
    lines = Prompt.read_to_list(__file__)

    return CPU(
        [int(i) for i in lines[-1].split(" ")[-1].split(",")],
        reg_a=int(lines[0].split(" ")[-1]),
        reg_b=int(lines[1].split(" ")[-1]),
        reg_c=int(lines[2].split(" ")[-1]),
    )
