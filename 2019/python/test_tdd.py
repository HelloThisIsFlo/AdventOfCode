from textwrap import dedent


from day_1 import Day1, full_required_all_inclusive


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
