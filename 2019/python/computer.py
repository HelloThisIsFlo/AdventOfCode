OP_SIZE = 4  # Constant (for now): 1 for code + 3 for params

class UnknownInstruction(Exception):
    pass


class UnableToSolve(Exception):
    pass


class Instruction:
    size = OP_SIZE

    @staticmethod
    def from_opcode(opcode, position, memory):
        def get_instruction_class():
            if opcode == 1:
                return AddInstruction
            elif opcode == 2:
                return MultiplyInstruction
            else:
                raise UnknownInstruction()

        op_class = get_instruction_class()
        return op_class(position, memory)

    def __init__(self, position, memory):
        self.address_of = {
            'parameter_1': memory[position + 1],
            'parameter_2': memory[position + 2],
            'output': memory[position + 3],
        }
        self.memory = memory
        self.parameter_1 = self.memory[self.address_of['parameter_1']]
        self.parameter_2 = self.memory[self.address_of['parameter_2']]

    def perform(self):
        result = self._do_perform()
        self.memory[self.address_of['output']] = result


class AddInstruction(Instruction):
    def _do_perform(self):
        return self.parameter_1 + self.parameter_2


class MultiplyInstruction(Instruction):
    def _do_perform(self):
        return self.parameter_1 * self.parameter_2


class Program:
    def __init__(self, memory, noun=None, verb=None):
        self.memory = memory
        if noun:
            self.memory[1] = noun
        if verb:
            self.memory[2] = verb

        self.instruction_pointer = 0
        self.current_instruction = self.instruction_at_pointer()

    def instruction_at_pointer(self):
        opcode = self.memory[self.instruction_pointer]
        if opcode == 99:
            return None

        return Instruction.from_opcode(
            opcode,
            self.instruction_pointer,
            self.memory
        )

    def go_to_next_instruction(self):
        self.instruction_pointer += self.current_instruction.size
        self.current_instruction = self.instruction_at_pointer()

    def run(self):
        while self.current_instruction:
            self.current_instruction.perform()
            self.go_to_next_instruction()

        return self.memory
