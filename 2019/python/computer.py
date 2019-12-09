from utils import SparseList
OPCODE_SIZE = 2

MODE_POSITION = 0
MODE_IMMEDIATE = 1


class UnknownInstruction(Exception):
    pass


class UnableToSolve(Exception):
    pass


class Instruction:
    @staticmethod
    def from_opcode(opcode, modes, position, memory):
        def get_instruction_class():
            if opcode == 1:
                return AddInstruction
            elif opcode == 2:
                return MultiplyInstruction
            else:
                raise UnknownInstruction()

        op_class = get_instruction_class()
        return op_class(modes, position, memory)

    def __init__(self, modes, position, memory):
        self.memory = memory
        self.num_of_input_params = 2
        self.num_of_output_params = 1

        address_of_output_param = position + self.num_of_input_params + 1
        self.address_of_output = memory[address_of_output_param]

        self.parameter = SparseList()
        for idx in range(self.num_of_input_params):
            if modes[idx] == MODE_POSITION:
                address_of_parameter = memory[position + 1 + idx]
                self.parameter[idx] = memory[address_of_parameter]
            elif modes[idx] == MODE_IMMEDIATE:
                self.parameter[idx] = memory[position + 1 + idx]

    def perform(self):
        result = self._do_perform()
        self.memory[self.address_of_output] = result

    @property
    def size(self):
        # Opcode&Modes + Params
        return 1 + self.num_of_input_params + self.num_of_output_params


class AddInstruction(Instruction):
    def _do_perform(self):
        return self.parameter[0] + self.parameter[1]


class MultiplyInstruction(Instruction):
    def _do_perform(self):
        return self.parameter[0] * self.parameter[1]


class Program:
    def __init__(self, memory, noun=None, verb=None):
        self.memory = SparseList(memory[:])
        if noun:
            self.memory[1] = noun
        if verb:
            self.memory[2] = verb

        self.instruction_pointer = 0
        self.current_instruction = self.instruction_at_pointer()

    def instruction_at_pointer(self):
        opcode_with_modes = '{:0>4d}'.format(
            self.memory[self.instruction_pointer]
        )
        opcode = int(opcode_with_modes[-OPCODE_SIZE::])
        modes = [int(mode) for mode in opcode_with_modes[:-OPCODE_SIZE:]]
        if opcode == 99:
            return None

        return Instruction.from_opcode(
            opcode,
            modes,
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
