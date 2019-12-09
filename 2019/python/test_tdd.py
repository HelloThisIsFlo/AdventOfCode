from textwrap import dedent
import pytest
from unittest import mock
from unittest.mock import patch, call, Mock


from utils import digitize, SparseList
from computer import Program

from day_1 import Day1, full_required_all_inclusive
from day_2 import Day2
from day_3 import Day3, trace_path, Up, Down, Left, Right, manhattan_dist_metric, step_on_wire_metric, IntersectionPoint
from day_4 import Day4, is_valid_pass, group


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
        assert Program([1, 0, 0, 0, 99]).run() == [2, 0, 0, 0, 99]

    def test_single_instruction_multiply(self):
        assert Program([2, 3, 0, 3, 99]).run() == [2, 3, 0, 6, 99]
        assert Program([2, 4, 4, 5, 99, 0]).run() == [2, 4, 4, 5, 99, 9801]

    def test_multiple_instructions(self):
        assert Program(
            [1, 1, 1, 4, 99, 5, 6, 0, 99]
        ).run() == [30, 1, 1, 4, 2, 5, 6, 0, 99]

    def test_it_replaces_noun_and_verb(self):
        noun = 4
        verb = 5
        program = Program([1, 2, 3, 4, 5, 6], noun=noun, verb=verb)
        assert program.memory[1] == noun
        assert program.memory[2] == verb

    def test_it_handles_opcodes_with_modes(self):
        # 1101: Operation 01 - Mode 110
        #       Add: Val of input1 + Val of input2
        #       Store: At adress of output
        # Input1: 100
        # Input2: -45
        # Output: 5 (store at address 5)
        #
        # 100 - 45 = 55 -> Stored in memory[5]
        assert Program(
            [1101, 100, -45, 5, 99]
        ).run() == [1101, 100, -45, 5, 99, 55]

    def test_opcode_mode_less_than_4_digits__assume_it_starts_with_zeros(self):
        # 101 ==> Understood as 0101
        # 0101: Operation 01 - Mode 010
        #       Add: Val at address of input1 + Val of input2
        #       Store: At adress of output
        # Input1: 2 (val at address: 30)
        # Input2: 30
        # Output: 5 (store at address 5)
        #
        # 30 + 30 = 60 -> Stored in memory[5]
        assert Program(
            [101, 2, 30, 5, 99]
        ).run() == [101, 2, 30, 5, 99, 60]

# TODO:
# 1) Pass the tests
# 2) Refactor to allow an arbitrary number of parameters


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
        @patch.object(Day2, 'parse_input')
        @patch('day_2.Program')
        def test_it_runs_program_with_correct_params(self, MockProgram, mock_parse_input):
            program = MockProgram.return_value
            program.run.return_value = [1, 0, 0, 0, 99]

            Day2("MOCK_INPUT").solve_part_1()

            MockProgram.assert_called_once_with(
                mock_parse_input.return_value,
                noun=12,
                verb=2
            )
            program.run.assert_called_once()

        @patch.object(Day2, 'parse_input')
        @patch('day_2.Program')
        def test_it_returns_formatted_result(self, MockProgram, mock_parse_input):
            program = MockProgram.return_value
            program.run.return_value = [12345, 0, 0, 0, 99]
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
