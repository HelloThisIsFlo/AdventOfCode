from textwrap import dedent

from solutions import Day1, Day2


def assert_solution_part_1(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_1() == expected_solution


def assert_solution_part_2(day_class, given_input, expected_solution):
    day = day_class(dedent(given_input))
    assert day.solve_part_2() == expected_solution


class TestDay1:
    class TestPart1:
        def test_single_number(self):
            assert_solution_part_1(Day1, given_input="""\
                +1
                """, expected_solution=1)

        def test_multiple_numbers(self):
            assert_solution_part_1(Day1, given_input="""\
                +1
                +1
                -44
                +127
                """, expected_solution=85)

    class TestPart2:
        def test_basic_example(self):
            assert_solution_part_2(Day1, given_input="""\
                +1
                -1
                """, expected_solution=0)

            assert_solution_part_2(Day1, given_input="""\
                +3
                +3
                +4
                -2
                -4
                """, expected_solution=10)

            assert_solution_part_2(Day1, given_input="""\
                -6
                +3
                +8
                +5
                -6
                """, expected_solution=5)

            assert_solution_part_2(Day1, given_input="""\
                +7
                +7
                -2
                -7
                -4
                """, expected_solution=14)


class TestDay2:
    class TestPart1:
        def test_single_entry(self):
            # No duplicate
            assert_solution_part_1(
                Day2,
                given_input="""\
                abcdef
                """,
                expected_solution=0)

            # Duplicate but no triplicate
            assert_solution_part_1(
                Day2,
                given_input="""\
                abbcde
                """,
                expected_solution=0)

            # Triplicate but no duplicate
            assert_solution_part_1(
                Day2,
                given_input="""\
                abcccd
                """,
                expected_solution=0)

            # Triplicate and duplicate
            assert_solution_part_1(
                Day2,
                given_input="""\
                bababc
                """,
                expected_solution=1)

        def test_example_from_the_problem_statement(self):
            assert_solution_part_1(
                Day2,
                given_input="""\
                    abcdef
                    bababc
                    abbcde
                    abcccd
                    aabcdd
                    abcdee
                    ababab
                """,
                expected_solution=12)

    class TestPart2:
        def test_example_from_the_problem_statement(self):
            # No duplicate
            assert_solution_part_2(
                Day2,
                given_input="""\
                    abcde
                    fghij
                    klmno
                    pqrst
                    fguij
                    axcye
                    wvxyz
                """,
                expected_solution='fgij')
