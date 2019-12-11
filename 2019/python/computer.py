from utils import SparseList
OPCODE_SIZE = 2

MODE_POSITION = 0
MODE_IMMEDIATE = 1

DEFAULT_NUM_OF_INPUT_PARAMS = 2
DEFAULT_NUM_OF_OUTPUT_PARAMS = 1


class UnknownInstruction(Exception):
    pass


class UnableToSolve(Exception):
    pass


def _get_mode(modes, param_idx):
    if param_idx < len(modes):
        return modes[param_idx]
    else:
        return None


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
                mode = _get_mode(modes, idx)
                if mode == MODE_POSITION or mode is None:
                    address_of_parameter = memory[position + 1 + idx]
                    self.input_parameters[idx] = memory[address_of_parameter]
                elif mode == MODE_IMMEDIATE:
                    self.input_parameters[idx] = memory[position + 1 + idx]
                else:
                    raise RuntimeError(f"Unknown mode: '{modes[idx]}'")

        self.memory = memory

        address_of_output_param = (
            position +
            self.num_of_input_params +
            self.num_of_output_params
        )
        self.address_of_output = memory[address_of_output_param]
        self.modes = format_modes(modes)

        self.input_parameters = SparseList()
        init_input_parameters()

    def perform(self):
        result = self._do_perform()
        self.memory[self.address_of_output] = result

    @property
    def size(self):
        # Opcode&Modes + Params
        return 1 + self.num_of_input_params + self.num_of_output_params

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
        opcode_with_modes = str(
            self.memory[self.instruction_pointer]
        )
        opcode = int(opcode_with_modes[-OPCODE_SIZE::])
        modes = [int(mode) for mode in opcode_with_modes[:-OPCODE_SIZE:]]
        modes.reverse()

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
