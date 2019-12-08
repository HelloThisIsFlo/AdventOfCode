from base import Day

OP_SIZE = 4  # Constant (for now): 1 for code + 3 for params


class Operation:
    @staticmethod
    def from_opcode(opcode, position, source):
        def get_opcode_class():
            if opcode == 1:
                return AddOperation
            elif opcode == 2:
                return MultiplyOperation
            else:
                raise NotImplementedError()

        op_class = get_opcode_class()
        return op_class(position, source)

    def __init__(self, position, source):
        self.source = source
        self.positions = {
            'input_1': self.source[position + 1],
            'input_2': self.source[position + 2],
            'output': self.source[position + 3],
        }
        self.input_1 = self.source[self.positions['input_1']]
        self.input_2 = self.source[self.positions['input_2']]

    def perform(self):
        result = self._do_perform()
        self.source[self.positions['output']] = result


class AddOperation(Operation):
    def _do_perform(self):
        return self.input_1 + self.input_2


class MultiplyOperation(Operation):
    def _do_perform(self):
        return self.input_1 * self.input_2


class Program:
    def __init__(self, source):
        self.source = source
        self.current_op_position = 0
        self.complete = False

    def perform_operation(self):
        opcode = self.source[self.current_op_position]

        if opcode == 99:
            self.complete = True
            return

        operation = Operation.from_opcode(
            opcode,
            self.current_op_position,
            self.source
        )
        operation.perform()

    def go_to_next_operation(self):
        self.current_op_position += OP_SIZE

    def run(self):
        while not self.complete:
            self.perform_operation()
            self.go_to_next_operation()

        return self.source


class Day2(Day):
    def parse_input(self):
        self.input = [int(num) for num in self.input.split(',')]

    def solve_part_1(self):
        self.parse_input()
        program = Program(self.input)
        result = program.run()
        return ','.join(str(num) for num in result)

    def solve_part_2(self):
        return 'todo'
