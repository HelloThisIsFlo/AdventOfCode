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
        return self.program.is_complete()


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

        signal = INITIAL_INPUT
        while not amp_0.is_halted():
            signal = amp_0.signal(signal)
            signal = amp_1.signal(signal)
            signal = amp_2.signal(signal)
            signal = amp_3.signal(signal)
            signal = amp_4.signal(signal)

        assert amp_1.is_halted()
        assert amp_2.is_halted()
        assert amp_3.is_halted()
        assert amp_4.is_halted()
        return signal


def max_thruster_signal(intcode, feedback_loop_mode=False):
    def try_all_permutations_and_find_max_output():
        pipeline = AmplifierPipeline(intcode)
        max_output = -1
        for candidate in permutations(phases):
            candidate_res = pipeline.run(*candidate)
            if candidate_res > max_output:
                max_output = candidate_res
        return max_output

    if feedback_loop_mode:
        phases = [5, 6, 7, 8, 9]
    else:
        phases = [0, 1, 2, 3, 4]

    return try_all_permutations_and_find_max_output()


class Day7(IntcodeDay):
    def solve_part_1(self):
        return str(max_thruster_signal(self.intcode))

    def solve_part_2(self):
        return str(max_thruster_signal(self.intcode, feedback_loop_mode=True))
