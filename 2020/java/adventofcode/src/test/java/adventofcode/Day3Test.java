package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day2.MinMaxPasswordValidator;
import adventofcode.day2.PositionPasswordValidator;
import adventofcode.day2.dto.PasswordWithPolicy;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class Day3Test {

  private Day3 day3;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    day3 = new Day3();
  }


  @Nested
  class Part1 {

  }

  @Nested
  class Part2 {

  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {

    }

    @Test
    @Disabled
    void part1_exampleFromTheProblemStatement() {
      day3.inputLines = List.of(
          "..##.......",
          "#...#...#..",
          ".#....#..#.",
          "..#.#...#.#",
          ".#...##..#.",
          "..#.##.....",
          ".#.#.#....#",
          ".#........#",
          "#.##...#...",
          "#...##....#",
          ".#..#...#.#"
      );

      String result = day3.solvePart1();

      assertEquals("2", result);
    }

    @Test
    @Disabled
    void part2_exampleFromTheProblemStatement() {
      day3.inputLines = List.of(
          "..##.......",
          "#...#...#..",
          ".#....#..#.",
          "..#.#...#.#",
          ".#...##..#.",
          "..#.##.....",
          ".#.#.#....#",
          ".#........#",
          "#.##...#...",
          "#...##....#",
          ".#..#...#.#"
      );

      String result = day3.solvePart2();

      assertEquals("1", result);
    }
  }


}