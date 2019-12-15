from base import IntcodeDay
from computer import Program


class Day9(IntcodeDay):
    def run_program_with_input_and_return_output(self, input_):
        program = Program(self.intcode)
        program.run(hardcoded_input=[input_], capture_output=True)
        return str(program.runtime.captured_output[0])

    def solve_part_1(self):
        return self.run_program_with_input_and_return_output(1)

    def solve_part_2(self):
        return self.run_program_with_input_and_return_output(2)
