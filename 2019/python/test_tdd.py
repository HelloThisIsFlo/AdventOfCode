from day_7 import max_thruster_signal
from textwrap import dedent
import pytest
from unittest import mock
from unittest.mock import patch, call, Mock


from utils import digitize, SparseList
from computer import Program, Runtime
from computer.instruction import Instruction

from day_1 import Day1, full_required_all_inclusive
from day_2 import Day2
from day_3 import Day3, trace_path, Up, Down, Left, Right, manhattan_dist_metric, step_on_wire_metric, IntersectionPoint
from day_4 import Day4, is_valid_pass, group
from day_6 import Orbit, orbit_count_checksum, Planet, min_orbital_transfers


def assert_solution_part_1(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_1() == expected_solution


def assert_solution_part_2(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_2() == expected_solution


class TestUtils:
    def test_digitizer(self):
        assert digitize(123456) == [1, 2, 3, 4, 5, 6]
        assert digitize(876543) == [8, 7, 6, 5, 4, 3]

    class TestSparseList:
        def test_regular_list_doesnt_allow_setting_values_at_any_index(self):
            list_ = [1, 2, 3, 4, 5, 6]
            with pytest.raises(IndexError):
                list_[10] = 'Hello'

        def test_sparse_list_allow_setting_values_at_any_index(self):
            sparse_list = SparseList([1, 2, 3, 4, 5, 6])
            sparse_list[10] = 'Hello'  # Does not raise
            assert sparse_list == [
                1, 2, 3, 4, 5, 6, None, None, None, None, 'Hello'
            ]

        def test_allow_custom_filler(self):
            sparse_list = SparseList([1, 2, 3, 4, 5, 6], filler=-1)
            sparse_list[10] = 'Hello'  # Does not raise
            assert sparse_list == [
                1, 2, 3, 4, 5, 6, -1, -1, -1, -1, 'Hello'
            ]


class TestProgram:
    def test_single_instruction_add(self):
        program = Program([1, 0, 0, 0, 99])
        program.run()
        assert program.runtime.memory == [2, 0, 0, 0, 99]

    def test_single_instruction_multiply(self):
        program1 = Program([2, 3, 0, 3, 99])
        program1.run()
        assert program1.runtime.memory == [2, 3, 0, 6, 99]

        program2 = Program([2, 4, 4, 5, 99, 0])
        program2.run()
        assert program2.runtime.memory == [2, 4, 4, 5, 99, 9801]

    def test_multiple_instructions(self):
        program = Program([1, 1, 1, 4, 99, 5, 6, 0, 99])
        program.run()
        assert program.runtime.memory == [30, 1, 1, 4, 2, 5, 6, 0, 99]

    def test_it_replaces_noun_and_verb(self):
        noun = 4
        verb = 5
        program = Program([1, 2, 3, 4, 5, 6], noun=noun, verb=verb)
        assert program.runtime.memory[1] == noun
        assert program.runtime.memory[2] == verb

    def test_it_handles_opcodes_with_modes(self):
        # 1101: Operation 01 - Mode 011 -> IN[1, 1] OUT[0]
        #       Add: Val of input1 + Val of input2
        #       Store: At adress of output
        # Input1: 100
        # Input2: -45
        # Output: 5 (store at address 5)
        #
        # 100 - 45 = 55 -> Stored in memory[5]
        program = Program([1101, 100, -45, 5, 99])
        program.run()
        assert program.runtime.memory == [
            1101, 100, -45, 5, 99, 55
        ]

    def test_opcode_mode_with_implicit_position_mode_for_param(self):
        # 101 ==> Understood as 00101
        # 00101: Operation 01 - Mode 001 -> IN[1, 0] OUT[0]
        #       Add: Val of input1 + Val at address of input2
        #       Store: At adress of output
        # Input1: 30
        # Input2: 1 (val at address: 30)
        # Output: 5 (store at address 5)
        #
        # 30 + 30 = 60 -> Stored in memory[5]
        program = Program([101, 30, 1, 5, 99])
        program.run()
        assert program.runtime.memory == [101, 30, 1, 5, 99, 60]

    def test_operation_with_more_than_2_input_params(self):
        # For the purpose of this feature, we will be implementing a
        # 'TripleAdd' operation, that adds 3 numbers together
        # Opcode for 'TripleAdd' == 98

        # In this program, one operation '1098'
        # Since 'TripleAdd' has 3 input parameter, '1098' will
        # be interpreted as '0010[modes]98[opcode]'

        program = Program([10098, 5, 0, 17, 6, 99])
        program.run()
        assert program.runtime.memory == [
            10098, 5, 0, 17, 6, 99, (99 + 10098 + 17)
        ]

    @pytest.fixture
    def assert_program(self):
        def do_assert_program(intcode, given_input, expected_output):
            program = Program(intcode)
            program.run(hardcoded_input=given_input, capture_output=True)
            assert program.runtime.captured_output == expected_output

        return do_assert_program

    def test_operation_with_no_output_param_position(self, assert_program):
        PRINT_NUMBER_12345_POSITION = [4, 3, 99, 12345]
        assert_program(
            PRINT_NUMBER_12345_POSITION,
            given_input=RuntimeError,
            expected_output=[12345]
        )

    def test_operation_with_no_output_param_immediate(self, assert_program):
        PRINT_NUMBER_12345_IMMEDIATE = [104, 12345, 99]
        assert_program(
            PRINT_NUMBER_12345_IMMEDIATE,
            given_input=RuntimeError,
            expected_output=[12345]
        )

    class TestInputOutput:
        @pytest.fixture
        def add_2_numbers_program(self):
            # The following intcode will:
            # 1. Request for user input [mock_value=111] & save @ 11
            # 2. Request for user input [mock_value=222] & save @ 12
            # 3. Add values at 11 & 12 (so the 2 inputted values) & save @ 13
            #    -> 111 + 222 == 333
            # 4. Output the result (value stored @ 13)
            # 5. End
            ADD_2_NUMBERS_INTCODE = [3, 11, 3, 12, 1, 11, 12, 13, 4, 13, 99]
            return Program(ADD_2_NUMBERS_INTCODE)

        @patch('computer.io.display_output_to_user')
        @patch('computer.io.prompt_user_for_input')
        def test_it_handles_user_input_in_interactive_mode(self, mock_prompt_user_for_input, mock_display_output_to_user, add_2_numbers_program: Program):
            def last_outputted_value():
                ((outputted_value,), _) = mock_display_output_to_user.call_args
                return outputted_value

            mock_prompt_user_for_input.side_effect = [111, 222]
            add_2_numbers_program.run(interactive_mode=True)
            assert last_outputted_value() == 333

        def test_it_allows_to_hardcode_user_input(self, add_2_numbers_program):
            add_2_numbers_program.run(
                hardcoded_input=[222, 333],
                capture_output=True
            )
            assert add_2_numbers_program.runtime.captured_output == [555]

        def test_interactive_mode_can_not_be_used_with_hardcoded_input(self, add_2_numbers_program: Program):
            with pytest.raises(ValueError):
                add_2_numbers_program.run(
                    hardcoded_input=[1, 2],
                    interactive_mode=True
                )

        @pytest.mark.skip
        def test_it_allows_to_programatically_provide_input(self, add_2_numbers_program: Program):
            add_2_numbers_program.run(interactive_mode=False, capture_output=True)
            add_2_numbers_program.input(1)
            add_2_numbers_program.input(3)
            assert add_2_numbers_program.runtime.captured_output == [4]

    class TestItHandlesJumpIfTrue:
        # Uses Jump-if-true to display 0 if the input was 0, or 1 otherwise
        ZERO_IF_ZERO_INTCODE = [
            3, 3, 1105, -1, 9, 1101, 0, 0, 12, 4, 12, 99, 1
        ]

        def test_it_does_not_jump(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[0],
                expected_output=[0]
            )

        def test_it_jumps(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[1],
                expected_output=[1]
            )

        def test_it_jumps_2(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[1234],
                expected_output=[1]
            )

    class TestItHandlesJumpIfFalse:
        # Uses Jump-if-false to display 0 if the input was 0, or 1 otherwise
        ZERO_IF_ZERO_INTCODE = [
            3, 12, 6, 12, 15, 1, 13, 14, 13, 4, 13, 99, -1, 0, 1, 9
        ]

        def test_it_does_not_jump(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[0],
                expected_output=[0]
            )

        def test_it_jumps(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[1],
                expected_output=[1]
            )

        def test_it_jumps_2(self, assert_program):
            assert_program(
                self.ZERO_IF_ZERO_INTCODE,
                given_input=[1234],
                expected_output=[1]
            )

    class TestItHandlesEquals:
        # Uses 'Equals' to output 1 if input is equal to 8, 0 otherwise
        IS_EQUAL_TO_8_INTCODE = [
            3, 9, 8, 9, 10, 9, 4, 9, 99, -1, 8
        ]

        def test_it_is_equal(self, assert_program):
            assert_program(
                self.IS_EQUAL_TO_8_INTCODE,
                given_input=[8],
                expected_output=[1]
            )

        def test_it_is_not_equal(self, assert_program):
            pass
            assert_program(
                self.IS_EQUAL_TO_8_INTCODE,
                given_input=[9],
                expected_output=[0]
            )

    class TestItHandlesLessThan:
        # Uses 'Less Than' to output 1 if input is less than 8, 0 otherwise
        IS_LESS_THAN_8_INTCODE = [
            3, 3, 1107, -1, 8, 3, 4, 3, 99
        ]

        def test_it_is_equal(self, assert_program):
            assert_program(
                self.IS_LESS_THAN_8_INTCODE,
                given_input=[3],
                expected_output=[1]
            )

        def test_it_is_not_equal(self, assert_program):
            pass
            assert_program(
                self.IS_LESS_THAN_8_INTCODE,
                given_input=[8],
                expected_output=[0]
            )

    class TestInstruction:
        def test_represent_modes_in_intuitive_order(self):
            class FiveInputParamInstruction(Instruction):
                @property
                def num_of_input_params(self):
                    return 5

            # For an instruction with 5 input params (6 total w/ output)
            # a mode+opcode string of '10XX' XX being the opcode is passed
            # as [1, 0] to the `Instruction` constructor
            # In reality what '10XX' represents for a 6 params instruction
            # is '000010XX' with the leading zeros being omitted. In addition to
            # that, the modes describe the parameters in reverse order, so for
            # example 'ABCDEFXX' would mean:
            # - 'A' <- Mode for param 6[idx=5] (output)
            # - 'B' <- Mode for param 5[idx=4] (input)
            # - 'C' <- Mode for param 4[idx=3] (input)
            # - 'D' <- Mode for param 3[idx=2] (input)
            # - 'E' <- Mode for param 2[idx=1] (input)
            # - 'F' <- Mode for param 1[idx=0] (input)
            #
            # A more intuitive representation would be:
            #     modes = [0, 1, 0, 0, 0, 0]
            # That way modes could be access with
            #     modes[idx_of_parameter]
            # So the mode for param 3[idx=2] would be: `modes[2]`

            # In that example, `modes = [1, 0]` passed in the constructor
            # would mean:
            # - Parameter 1[idx=0] is in POSITION mode
            # - Parameter 2[idx=1] is in IMMEDIATE mode
            # - Parameters 3[idx=2] to 6[idx=6] are in POSITION mode
            # So `instruction.modes` should be formatted:
            #     instruction.modes = [0, 1, 0, 0, 0, 0]

            modes = [1, 0]
            instruction = FiveInputParamInstruction(
                modes,
                Runtime([0, 0, 0, 0, 0, 0, 0, 0])
            )

            assert instruction.modes == [0, 1, 0, 0, 0, 0]


class TestDay1:
    class TestPart1:
        def test_single_module(self):
            assert_solution_part_1(
                Day1,
                given_input="""\
                12
                """,
                expected_solution='2'
            )
            assert_solution_part_1(
                Day1,
                given_input="""\
                1969
                """,
                expected_solution='654'
            )

        def test_multiple_module(self):
            assert_solution_part_1(
                Day1,
                given_input="""\
                12
                1969
                """,
                expected_solution='656'
            )

    class TestFuelAllInclusive:
        def test_from_example(self):
            assert full_required_all_inclusive(14) == 2
            assert full_required_all_inclusive(1969) == 966


class TestDay2:
    class TestPart1:
        @patch.object(Day2, 'intcode')
        @patch('day_2.Program')
        def test_it_runs_program_with_correct_params(self, MockProgram, mock_intcode):
            program = MockProgram.return_value
            program.run.return_value = [1, 0, 0, 0, 99]

            Day2("MOCK_INPUT").solve_part_1()

            MockProgram.assert_called_once_with(
                mock_intcode,
                noun=12,
                verb=2
            )
            program.run.assert_called_once()

        @patch.object(Day2, 'intcode')
        @patch('day_2.Program')
        def test_it_returns_formatted_result(self, MockProgram, mock_intcode):
            program = MockProgram.return_value
            program.runtime.memory = [12345, 0, 0, 0, 99]
            expected_result = '12345'

            result = Day2("MOCK_INPUT").solve_part_1()

            assert result == expected_result


class TestDay3:
    MOCK_INPUT = dedent("""\
        U11, D22, L33, R44
        L11, R22, U33, D44
        """)

    def test_trace_path(self):
        assert trace_path(
            (0, 0),
            Up(3),
            Right(4),
            Down(1),
            Left(2)
        ) == [
            # (x,y)
            # Origin
            (0, 0),
            # 3 Up
            (0, 1),
            (0, 2),
            (0, 3),
            # 4 Right
            (1, 3),
            (2, 3),
            (3, 3),
            (4, 3),
            # 1 Down
            (4, 2),
            # 2 Left
            (3, 2),
            (2, 2),
        ]

    @patch('day_3.find_closest', return_value=(0, 0))
    @patch('day_3.trace_path')
    def test_call_trace_path_with_parsed_vectors_for_each_wire(self, mock_trace_path, mock_find_closest):
        Day3(dedent("""\
        U10, D3, R192, L44
        R44, L12, D200, R2, U53
        """)).closest_point_from_origin(metric=Mock())

        mock_trace_path.assert_has_calls([
            call((0, 0), Up(10), Down(3), Right(192), Left(44)),
            call((0, 0), Right(44), Left(12), Down(200), Right(2), Up(53))
        ])

    @patch('day_3.find_closest', return_value=(0, 0))
    @patch('day_3.intersection')
    @patch('day_3.trace_path')
    def test_find_intersection(self, mock_trace_path, mock_intersection, mock_find_closest):
        wire1_path = Mock()
        wire2_path = Mock()
        mock_trace_path.side_effect = [wire1_path, wire2_path]

        Day3(self.MOCK_INPUT).closest_point_from_origin(metric=Mock())

        mock_intersection.assert_called_once_with(wire1_path, wire2_path)

    @patch('day_3.find_closest', return_value=(0, 0))
    @patch('day_3.intersection')
    @patch('day_3.trace_path')
    def test_find_closest(self, mock_trace_path, mock_intersection, mock_find_closest):
        metric = Mock()
        Day3(self.MOCK_INPUT).closest_point_from_origin(metric=metric)

        mock_find_closest.assert_called_once_with(
            (0, 0),
            mock_intersection.return_value,
            metric=metric
        )

    @patch('day_3.find_closest')
    @patch('day_3.intersection')
    @patch('day_3.trace_path')
    def test_returns_value_given_by_metric_between_origin_and_closest_point(self, mock_trace_path, mock_intersection, mock_find_closest):
        metric = Mock(name='metric')

        day3 = Day3(self.MOCK_INPUT)
        result = day3.closest_point_from_origin(metric=metric)

        metric.assert_called_with(day3.origin, mock_find_closest.return_value)
        assert result == metric.return_value

    def test_part_1(self):
        assert_solution_part_1(
            Day3,
            given_input="""\
            R75,D30,R83,U83,L12,D49,R71,U7,L72
            U62,R66,U55,R34,D71,R55,D58,R83
            """,
            expected_solution='159'
        )

    def test_part_2(self):
        assert_solution_part_2(
            Day3,
            given_input="""\
            R75,D30,R83,U83,L12,D49,R71,U7,L72
            U62,R66,U55,R34,D71,R55,D58,R83
            """,
            expected_solution='610'
        )


class TestDay4:
    def test_is_valid_password(self):
        assert is_valid_pass(111111, range(999999)) is True

        # Not 6 digits
        assert is_valid_pass(12345, range(999999)) is False
        # Not in range
        assert is_valid_pass(333333, range(222222)) is False
        # Does not have 2 adjacent digits the same
        assert is_valid_pass(123456, range(999999)) is False
        # Decreases at the end
        assert is_valid_pass(223450, range(999999)) is False

    def test_is_valid_password_strict_adjacent_rule(self):
        def is_strict_adj_valid(pass_):
            return is_valid_pass(
                pass_,
                range(999999),
                strict_adjacent_rule=True
            )

        assert is_strict_adj_valid(112233) is True
        assert is_strict_adj_valid(111122) is True
        assert is_strict_adj_valid(112333) is True
        assert is_strict_adj_valid(111223) is True

        # Too many similar adjacent digits
        assert is_strict_adj_valid(111111) is False
        assert is_strict_adj_valid(123444) is False

    def test_group(self):
        assert group([1, 1, 2, 3, 4, 5, 5, 6]) == [
            [1, 1],
            [2],
            [3],
            [4],
            [5, 5],
            [6]
        ]

    def test_does_not_raise(self):
        Day4(dedent("""\
            11231-11217
            """)).solve_part_1()
        Day4(dedent("""\
            11231-11217
            """)).solve_part_2()


class TestDay6:
    class TestCheckSum:
        def test_only_direct_orbits(self):
            orbits = [
                Orbit('COM', 'A'),
                Orbit('COM', 'B'),
                Orbit('COM', 'C'),
                Orbit('COM', 'D')
            ]
            assert orbit_count_checksum(orbits) == 4

        def test_simple_indirect_orbit(self):
            # COM -> A -> B -> C
            # Direct orbits: 3 (1 orbit is exactly 1 direct orbit)
            # Indirect orbits: 3
            # - C: A, COM
            # - B: COM
            orbits = [
                Orbit('COM', 'A'),
                Orbit('A', 'B'),
                Orbit('B', 'C')
            ]
            assert orbit_count_checksum(orbits) == 3 + 3

        def test_from_example(self):
            # See: https://adventofcode.com/2019/day/6
            orbits = [
                Orbit('COM', 'B'),
                Orbit('B', 'C'),
                Orbit('C', 'D'),
                Orbit('D', 'E'),
                Orbit('E', 'F'),
                Orbit('B', 'G'),
                Orbit('G', 'H'),
                Orbit('D', 'I'),
                Orbit('E', 'J'),
                Orbit('J', 'K'),
                Orbit('K', 'L'),
            ]
            assert orbit_count_checksum(orbits) == 42

    class TestPlanet:
        def test_equality(self):
            com = Planet('COM', orbits_around=None)
            com_bis = Planet('COM', orbits_around=None)
            a = Planet('A', orbits_around=com)
            b = Planet('B', orbits_around=com)
            a_bis = Planet('A', orbits_around=com)
            not_a = Planet('A', orbits_around=b)

            assert a == a_bis
            assert com == com_bis
            assert a != not_a
            assert a != b

        class TestBuildAllFromOrbits:
            def test_valid_orbits(self):
                com = Planet('COM', orbits_around=None)
                planet_a = Planet('A', orbits_around=com)
                planet_b = Planet('B', orbits_around=com)
                planet_c = Planet('C', orbits_around=planet_a)
                planet_d = Planet('D', orbits_around=planet_b)

                assert Planet.build_all_from_orbits([
                    Orbit('COM', 'A'),
                    Orbit('COM', 'B'),
                    Orbit('A', 'C'),
                    Orbit('B', 'D')
                ]) == {
                    com,
                    planet_a,
                    planet_b,
                    planet_c,
                    planet_d
                }

            def test_can_not_orbit_2_planets(self):
                with pytest.raises(ValueError):
                    # B orbits 'A' and 'COM' => Impossible
                    Planet.build_all_from_orbits([
                        Orbit('COM', 'A'),
                        Orbit('A', 'B'),
                        Orbit('COM', 'B')
                    ])

    class TestMinOrbitalTransfers:
        def test_from_example(self):
            orbits = [
                Orbit('COM', 'B'),
                Orbit('B', 'C'),
                Orbit('C', 'D'),
                Orbit('D', 'E'),
                Orbit('E', 'F'),
                Orbit('B', 'G'),
                Orbit('G', 'H'),
                Orbit('D', 'I'),
                Orbit('E', 'J'),
                Orbit('J', 'K'),
                Orbit('K', 'L'),
                Orbit('K', 'YOU'),
                Orbit('I', 'SAN')
            ]

            assert min_orbital_transfers(orbits) == 4


class TestDay7:
    class TestPart1:
        def test_from_examples(self):
            assert max_thruster_signal(
                [3, 23, 3, 24, 1002, 24, 10, 24, 1002, 23, -1, 23,
                    101, 5, 23, 23, 1, 24, 23, 23, 4, 23, 99, 0, 0]
            ) == 54321
            assert max_thruster_signal(
                [3, 15, 3, 16, 1002, 16, 10, 16, 1, 16, 15, 15, 4, 15, 99, 0, 0]
            ) == 43210
            assert max_thruster_signal(
                [3, 31, 3, 32, 1002, 32, 10, 32, 1001, 31, -2, 31, 1007, 31, 0, 33,
                    1002, 33, 7, 33, 1, 33, 31, 31, 1, 32, 31, 31, 4, 31, 99, 0, 0, 0]
            ) == 65210

    class TestPart2:
        @pytest.mark.skip
        def test_from_examples(self):
            assert max_thruster_signal(
                [3, 26, 1001, 26, -4, 26, 3, 27, 1002, 27, 2, 27, 1, 27, 26,
                    27, 4, 27, 1001, 28, -1, 28, 1005, 28, 6, 99, 0, 0, 5],
                feedback_loop_mode=True
            ) == 139629729
            assert max_thruster_signal(
                [3, 52, 1001, 52, -5, 52, 3, 53, 1, 52, 56, 54, 1007, 54, 5, 55, 1005, 55, 26, 1001, 54,
                    -5, 54, 1105, 1, 12, 1, 53, 54, 53, 1008, 54, 0, 55, 1001, 55, 1, 55, 2, 53, 55, 53, 4,
                    53, 1001, 56, -1, 56, 1005, 56, 6, 99, 0, 0, 0, 0, 10],
                feedback_loop_mode=True
            ) == 18216
