from base import Day
from computer import Program, UnableToSolve


class Day5(Day):
    def parse_input(self):
        return [int(num) for num in self.input.split(',')]

    def run_program_from_input(self):
        parsed_input = self.parse_input()
        program = Program(parsed_input)
        program.run()

    def solve_part_1(self):
        self.run_program_from_input()

    def solve_part_2(self):
        self.run_program_from_input()
