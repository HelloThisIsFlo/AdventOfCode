from itertools import permutations

from base import IntcodeDay
from computer import Program

INITIAL_INPUT = 0


class Amplifier:
    def __init__(self, intcode, phase):
        self.program = Program(intcode[:])
        self.phase = phase

    def start(self):
        self.program.run(interactive_mode=False, capture_output=True)
        self.program.input(self.phase)

    def signal(self, signal_in):
        self.program.input(signal_in)
        return self.program.runtime.captured_output[-1]

    def is_halted(self):
        pass


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

        amp_0.start()
        amp_1.start()
        amp_2.start()
        amp_3.start()
        amp_4.start()

        return \
            amp_4.signal(
                amp_3.signal(
                    amp_2.signal(
                        amp_1.signal(
                            amp_0.signal(INITIAL_INPUT)
                        )
                    )
                )
            )


def max_thruster_signal(intcode, feedback_loop_mode=False):
    if feedback_loop_mode:
        return temp_rename(intcode)

    pipeline = AmplifierPipeline(intcode)
    max_output = -1
    for candidate in permutations([0, 1, 2, 3, 4]):
        candidate_res = pipeline.run(*candidate)
        if candidate_res > max_output:
            max_output = candidate_res
    return max_output


def temp_rename(intcode):
    pipeline = AmplifierPipeline(intcode)

    amp_0 = pipeline.new_amplifier(9)
    amp_1 = pipeline.new_amplifier(8)
    amp_2 = pipeline.new_amplifier(7)
    amp_3 = pipeline.new_amplifier(6)
    amp_4 = pipeline.new_amplifier(5)

    pass


class Day7(IntcodeDay):
    def solve_part_1(self):
        return str(max_thruster_signal(self.intcode))

    def solve_part_2(self):
        pass
