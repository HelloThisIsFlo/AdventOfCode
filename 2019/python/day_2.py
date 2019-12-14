from base import IntcodeDay
from computer import Program, UnableToSolve


class Day2(IntcodeDay):
    def solve_part_1(self):
        program = Program(self.intcode, noun=12, verb=2)
        program.run()
        return str(program.runtime.memory[0])

    def solve_part_2(self):
        expected_output = 19690720

        for noun in range(100):
            for verb in range(100):
                program = Program(
                    self.intcode[:],
                    noun=noun,
                    verb=verb
                )
                program.run()
                if program.runtime.memory[0] == expected_output:
                    return 100 * noun + verb

        raise UnableToSolve()
