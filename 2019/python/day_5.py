from base import Day
from computer import Program, UnableToSolve


class Day5(Day):
    def parse_input(self):
        return [int(num) for num in self.input.split(',')]

    def solve_part_1(self):
        parsed_input = self.parse_input()
        program = Program(parsed_input)
        program.run()
        return 'No output, check printed output for result (last OUTPUT not 0)'

    def solve_part_2(self):
        pass
