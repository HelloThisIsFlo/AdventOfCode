from days.day import Day


class Day3(Day):
    def __init__(self, input_as_string: str):
        super().__init__(input_as_string)
        lines = self.input_lines(str)
        self.bits = len(lines[0])
        self.length = len(lines)
        self.ones = [0] * self.bits
        for line in lines:
            for i in range(self.bits):
                if line[i] == '1':
                    self.ones[i] += 1

    def solve_part_1(self):
        return str(self.gamma() * self.epsilon())

    def solve_part_2(self):
        return "asdf"

    def gamma(self):
        gamma_bin = ['0'] * self.bits
        for i in range(self.bits):
            if self.most_common_at(i) == '1':
                gamma_bin[i] = '1'

        return self.bin_str_to_int(gamma_bin)

    def epsilon(self):
        epsilon_bin = ['1'] * self.bits
        for i in range(self.bits):
            if self.most_common_at(i) == '1':
                epsilon_bin[i] = '0'

        return self.bin_str_to_int(epsilon_bin)

    def most_common_at(self, i):
        if self.ones[i] > (self.length / 2):
            return '1'
        elif self.ones[i] == (self.length / 2):
            return 'x'
        else:
            return '0'

    @staticmethod
    def bin_str_to_int(gamma_bin):
        return int(''.join(gamma_bin), 2)
