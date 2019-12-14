from itertools import permutations

from base import IntcodeDay
from computer import Program

INITIAL_INPUT = 0


class Amplifier:
    def __init__(self, intcode, phase):
        self.program = Program(intcode[:])
        self.phase = phase

    def run(self, input_):
        self.program.run(
            hardcoded_input=[self.phase, input_],
            capture_output=True
        )
        return self.program.runtime.captured_output[0]


class AmplifierPipeline:
    def __init__(self, intcode):
        self.intcode = intcode

    def new_amplifier(self, phase):
        return Amplifier(self.intcode, phase)

    def run(self, phase_0, phase_1, phase_2, phase_3, phase_4):
        amp_0 = self.new_amplifier(phase_0)
        amp_1 = self.new_amplifier(phase_1)
        amp_2 = self.new_amplifier(phase_2)
        amp_3 = self.new_amplifier(phase_3)
        amp_4 = self.new_amplifier(phase_4)

        return \
            amp_4.run(
                amp_3.run(
                    amp_2.run(
                        amp_1.run(
                            amp_0.run(INITIAL_INPUT)
                        )
                    )
                )
            )


def max_thruster_signal(intcode, feedback_loop_mode=False):
    pipeline = AmplifierPipeline(intcode)
    max_output = -1
    for candidate in permutations([0, 1, 2, 3, 4]):
        candidate_res = pipeline.run(*candidate)
        if candidate_res > max_output:
            max_output = candidate_res
    return max_output


class Day7(IntcodeDay):
    def solve_part_1(self):
        return str(max_thruster_signal(self.intcode))

    def solve_part_2(self):
        pass
