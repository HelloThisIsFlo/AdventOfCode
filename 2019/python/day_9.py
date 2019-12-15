from base import IntcodeDay
from computer import Program


class Day9(IntcodeDay):
    def solve_part_1(self):
        program = Program(self.intcode)
        program.run(hardcoded_input=[1], capture_output=True)
        return str(program.runtime.captured_output[0])

    def solve_part_2(self):
        pass
