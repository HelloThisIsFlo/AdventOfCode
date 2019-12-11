from utils import SparseList
OPCODE_SIZE = 2

MODE_POSITION = 0
MODE_IMMEDIATE = 1

DEFAULT_NUM_OF_INPUT_PARAMS = 2
DEFAULT_NUM_OF_OUTPUT_PARAMS = 1


class UnknownInstruction(Exception):
    def __init__(self, opcode):
        super().__init__(f'OpCode={opcode}')


class UnableToSolve(Exception):
    pass


def _get_mode(modes, param_idx):
    if param_idx < len(modes):
        return modes[param_idx]
    else:
        return None


class Instruction:
    @staticmethod
    def from_opcode(opcode, modes, runtime):
        def get_instruction_class():
            if opcode == 1:
                return AddInstruction
            elif opcode == 2:
                return MultiplyInstruction
            elif opcode == 3:
                return FakeInputInstruction
            elif opcode == 4:
                return FakeOutputInstruction
            elif opcode == 98:
                return TripleAddInstruction
            else:
                raise UnknownInstruction(opcode)

        op_class = get_instruction_class()
        return op_class(modes, runtime)

    def __init__(self, modes, runtime):
        def format_modes(modes):
            def set_missing_modes_to_position():
                for param_idx in range(self.num_of_input_params + self.num_of_output_params):
                    if param_idx >= len(formatted_modes):
                        formatted_modes.append(MODE_POSITION)

            formatted_modes = modes[:]
            formatted_modes.reverse()
            set_missing_modes_to_position()
            return formatted_modes

        def init_input_parameters():
            for idx in range(self.num_of_input_params):
                if self.modes[idx] == MODE_POSITION:
                    address_of_parameter = runtime.memory[runtime.pointer + 1 + idx]
                    self.input_parameters[idx] = runtime.memory[address_of_parameter]

                elif self.modes[idx] == MODE_IMMEDIATE:
                    self.input_parameters[idx] = runtime.memory[runtime.pointer + 1 + idx]

                else:
                    raise RuntimeError(f"Unknown mode: '{modes[idx]}'")

        # Direct reference, no copy. Instructions modify the memory & the pointer
        self.runtime = runtime

        address_of_output_param = (
            runtime.pointer +
            self.num_of_input_params +
            self.num_of_output_params
        )
        self.address_of_output = runtime.memory[address_of_output_param]
        self.modes = format_modes(modes)

        self.input_parameters = SparseList()
        init_input_parameters()

    def perform(self):
        result = self._do_perform()
        self.runtime.memory[self.address_of_output] = result

    @property
    def size(self):
        # Opcode&Modes + Params
        return 1 + self.num_of_input_params + self.num_of_output_params

    def move_pointer_to_next_instruction(self):
        self.runtime.pointer += self.size

    @property
    def num_of_input_params(self):
        return DEFAULT_NUM_OF_INPUT_PARAMS

    @property
    def num_of_output_params(self):
        return DEFAULT_NUM_OF_OUTPUT_PARAMS


class AddInstruction(Instruction):
    def _do_perform(self):
        return self.input_parameters[0] + self.input_parameters[1]


class MultiplyInstruction(Instruction):
    def _do_perform(self):
        return self.input_parameters[0] * self.input_parameters[1]


class TripleAddInstruction(Instruction):
    @property
    def num_of_input_params(self):
        return 3

    def _do_perform(self):
        return (
            self.input_parameters[0] +
            self.input_parameters[1] +
            self.input_parameters[2]
        )


class FakeInputInstruction(Instruction):
    @property
    def num_of_input_params(self):
        return 0

    def _do_perform(self):
        print(f'<<< INPUT: 1')
        return 1


class FakeOutputInstruction(Instruction):
    @property
    def num_of_input_params(self):
        return 0

    def _do_perform(self):
        # Output doesn't have an input, but the base `Instruction`
        # will write the return value of this function to
        # `self.address_of_output`
        # To prevent overriding with None, we simply return the existing
        # value
        output_value = self.memory[self.address_of_output]
        print(f'>>> OUTPUT: {output_value}')
        return output_value


class Runtime:
    def __init__(self, memory):
        self.pointer = 0
        self.memory = SparseList(memory[:])


class Program:
    def __init__(self, memory, noun=None, verb=None):
        self.runtime = Runtime(memory)
        if noun:
            self.runtime.memory[1] = noun
        if verb:
            self.runtime.memory[2] = verb

        self.current_instruction = self.instruction_at_pointer()

    def instruction_at_pointer(self):
        def extract_opcode_and_modes():
            # opcode_with_modes: 'ABCDEF' with 'ABCD' <- mode & 'EF' <- Opcode
            opcode_with_modes = str(
                self.runtime.memory[self.runtime.pointer]
            )
            # opcode: 'ABCDEF' -> int('EF')
            opcode = int(opcode_with_modes[-OPCODE_SIZE::])
            # modes: 'ABCDEF' -> [a, b, c, d] where x == int(X)
            modes = [int(mode) for mode in opcode_with_modes[:-OPCODE_SIZE:]]

            return opcode, modes

        opcode, modes = extract_opcode_and_modes()

        if opcode == 99:
            return None

        return Instruction.from_opcode(
            opcode,
            modes,
            self.runtime
        )

    def go_to_next_instruction(self):
        self.current_instruction.move_pointer_to_next_instruction()
        self.current_instruction = self.instruction_at_pointer()

    def run(self):
        while self.current_instruction:
            self.current_instruction.perform()
            self.go_to_next_instruction()

        return self.runtime.memory
