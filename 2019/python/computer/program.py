from utils import SparseList
from . import io
from .instruction import Instruction

OPCODE_SIZE = 2


class UnableToSolve(Exception):
    pass


def _get_mode(modes, param_idx):
    if param_idx < len(modes):
        return modes[param_idx]
    else:
        return None


class Runtime:
    def __init__(self, memory):
        self.pointer = 0
        self.memory = SparseList(memory[:])


3, 21, 1008, 21, 8, 20, 1005, 20, 22, 107, 8, 21, 20, 1006, 20, 31, 1106, 0, 36, 98, 0, 0, 1002, 21, 125, 20, 4, 20, 1105, 1, 46, 104, 999, 1105, 1, 46, 1101, 1000, 1, 20, 4, 20, 1105, 1, 46, 98, 99


class Program:
    def __init__(self, memory, noun=None, verb=None):
        self.runtime = Runtime(memory)
        if noun:
            self.runtime.memory[1] = noun
        if verb:
            self.runtime.memory[2] = verb

        self.current_instruction = self.instruction_at_pointer()

    def instruction_at_pointer(self):
        def extract_opcode_and_modes():
            # opcode_with_modes: 'ABCDEF' with 'ABCD' <- mode & 'EF' <- Opcode
            opcode_with_modes = str(
                self.runtime.memory[self.runtime.pointer]
            )
            # opcode: 'ABCDEF' -> int('EF')
            opcode = int(opcode_with_modes[-OPCODE_SIZE::])
            # modes: 'ABCDEF' -> [a, b, c, d] where x == int(X)
            modes = [int(mode) for mode in opcode_with_modes[:-OPCODE_SIZE:]]

            return opcode, modes

        opcode, modes = extract_opcode_and_modes()

        if opcode == 99:
            return None

        return Instruction.from_opcode(
            opcode,
            modes,
            self.runtime
        )

    def go_to_next_instruction(self):
        self.current_instruction.move_pointer_to_next_instruction()
        self.current_instruction = self.instruction_at_pointer()

    def run(self):
        while self.current_instruction:
            self.current_instruction.perform()
            self.go_to_next_instruction()

        return None
