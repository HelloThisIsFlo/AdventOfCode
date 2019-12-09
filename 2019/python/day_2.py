from base import Day
from computer import Program, UnableToSolve

class Day2(Day):
    def parse_input(self):
        return [int(num) for num in self.input.split(',')]

    def solve_part_1(self):
        parsed_input = self.parse_input()
        program = Program(parsed_input, noun=12, verb=2)
        result = program.run()
        return str(result[0])

    def solve_part_2(self):
        expected_output = 19690720
        parsed_input = self.parse_input()

        for noun in range(100):
            for verb in range(100):
                program = Program(
                    parsed_input.copy(),
                    noun=noun,
                    verb=verb
                )
                result = program.run()
                if result[0] == expected_output:
                    return 100 * noun + verb

        raise UnableToSolve()
