from base import IntcodeDay
from computer import Program, UnableToSolve


class Day5(IntcodeDay):
    def run_program_from_input(self):
        program = Program(self.intcode)
        program.run(interactive_mode=True)

    def solve_part_1(self):
        self.run_program_from_input()

    def solve_part_2(self):
        self.run_program_from_input()
