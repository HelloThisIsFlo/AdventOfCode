from textwrap import dedent
import pytest
from unittest import mock
from unittest.mock import patch, call, Mock


from day_1 import Day1, full_required_all_inclusive
from day_2 import Day2, Program
from day_3 import Day3, trace_path, Up, Down, Left, Right


def assert_solution_part_1(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_1() == expected_solution


def assert_solution_part_2(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_2() == expected_solution


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
        """)).solve_part_1()

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

        Day3(self.MOCK_INPUT).solve_part_1()

        mock_intersection.assert_called_once_with(wire1_path, wire2_path)

    @patch('day_3.find_closest', return_value=(0, 0))
    @patch('day_3.intersection')
    @patch('day_3.trace_path')
    def test_find_closest(self, mock_trace_path, mock_intersection, mock_find_closest):
        Day3(self.MOCK_INPUT).solve_part_1()

        mock_find_closest.assert_called_once_with(
            (0, 0),
            mock_intersection.return_value
        )

    @patch('day_3.find_closest')
    @patch('day_3.intersection')
    @patch('day_3.trace_path')
    def test_returns_manhattan_distance_to_the_closest_point(self, mock_trace_path, mock_intersection, mock_find_closest):
        mock_find_closest.return_value = (3, 5)
        assert Day3(self.MOCK_INPUT).solve_part_1() == '8'
