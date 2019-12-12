from utils import SparseList
from . import io
OPCODE_SIZE = 2

MODE_POSITION = 0
MODE_IMMEDIATE = 1


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
            class_ = {
                1: AddInstruction,
                2: MultiplyInstruction,
                3: InputInstruction,
                4: OutputInstruction,
                5: JumpIfTrueInstruction,
                98: TripleAddInstruction
            }.get(opcode)
            if not class_:
                raise UnknownInstruction(opcode)
            return class_

        op_class = get_instruction_class()
        return op_class(modes, runtime)

    def __init__(self, modes, runtime):
        def format_modes(modes):
            def set_missing_modes_to_position():
                for param_idx in range(self.num_of_input_params + self.has_output_param):
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
        self.pointer_moved_by_perform_phase = False

        if self.has_output_param:
            address_of_output_param = (
                runtime.pointer +
                self.num_of_input_params +
                self.has_output_param
            )
            self.address_of_output = runtime.memory[address_of_output_param]
        else:
            self.address_of_output = None

        self.modes = format_modes(modes)

        self.input_parameters = SparseList()
        init_input_parameters()

    def perform(self):
        result = self._do_perform()
        if self.has_output_param:
            self.runtime.memory[self.address_of_output] = result

    @property
    def size(self):
        # Opcode&Modes + Params
        return 1 + self.num_of_input_params + self.has_output_param

    def move_pointer_to_next_instruction(self):
        if not self.pointer_moved_by_perform_phase:
            self.runtime.pointer += self.size

    @property
    def num_of_input_params(self):
        return 2

    @property
    def has_output_param(self):
        return True


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


class InputInstruction(Instruction):
    @property
    def num_of_input_params(self):
        return 0

    def _do_perform(self):
        return io.prompt_user_for_input()


class OutputInstruction(Instruction):
    @property
    def num_of_input_params(self):
        return 1

    @property
    def has_output_param(self):
        return False

    def _do_perform(self):
        io.display_output_to_user(self.input_parameters[0])


class JumpIfTrueInstruction(Instruction):
    @property
    def has_output_param(self):
        return False

    def _do_perform(self):
        if self.input_parameters[0] != 0:
            self.runtime.pointer = self.input_parameters[1]
            self.pointer_moved_by_perform_phase = True


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
