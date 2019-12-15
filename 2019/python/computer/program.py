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
        self.memory = SparseList(memory[:], filler=0)
        self._hardcoded_input = None
        self._hardcoded_input_gen = None
        self._next_input = None
        self.waiting_for_input = False
        self.capture_output = False
        self.captured_output = []

    @property
    def hardcoded_input(self):
        return self._hardcoded_input

    @hardcoded_input.setter
    def hardcoded_input(self, hardcoded_input):
        def hardcoded_input_gen():
            for input_ in self._hardcoded_input:
                yield input_

        self._hardcoded_input = hardcoded_input
        self._hardcoded_input_gen = hardcoded_input_gen()

    @property
    def next_input(self):
        return self._next_input

    @next_input.setter
    def next_input(self, input_):
        self._next_input = input_
        self.waiting_for_input = False

    def next_hardcoded_input(self):
        return self._hardcoded_input_gen.__next__()


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

    def run(self, interactive_mode=False, hardcoded_input=None, capture_output=False, ):
        if interactive_mode and hardcoded_input:
            raise ValueError(
                "Interactive mode can not be used with hardcoded input"
            )

        self.runtime.interactive_mode = interactive_mode
        self.runtime.hardcoded_input = hardcoded_input
        self.runtime.capture_output = capture_output

        self._do_run()

        return None

    def input(self, input_):
        self.runtime.next_input = input_
        self._do_run()

    def _do_run(self):
        while self.current_instruction and not self.runtime.waiting_for_input:
            self.current_instruction.perform()
            self.go_to_next_instruction()

    def is_complete(self):
        return not self.runtime.waiting_for_input
