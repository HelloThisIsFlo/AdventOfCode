package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyInt;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day3.Mountainside;
import adventofcode.day3.MountainsideFactory;
import adventofcode.day3.Square;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class Day3Test {

  @Mock
  Mountainside mountainside;
  @Mock
  MountainsideFactory mountainsideFactory;
  private Day3 day3;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    when(mountainsideFactory.newMountainside(any())).thenReturn(mountainside);
    when(mountainside.move(anyInt(), anyInt())).thenReturn(Square.NO_TREE);
    when(mountainside.reachedBottom()).thenReturn(true);
    day3 = new Day3(mountainsideFactory);
  }


  @Nested
  class Part1 {

    @Test
    void itGetsAMountainsideFromTheFactoryWithTheInputLines() {
      day3.inputLines = List.of(
          "..##.......",
          "#...#...#..",
          "..##......."
      );

      day3.solvePart1();

      verify(mountainsideFactory).newMountainside(List.of(
          "..##.......",
          "#...#...#..",
          "..##......."
      ));
    }

    @Test
    void itMove3right1downUntilItReachesBottom() {
      when(mountainside.reachedBottom())
          // 7 times false, then true
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(true);

      day3.solvePart1();

      // Move was called 7 times
      verify(mountainside, times(7)).move(3, 1);
    }

    @Test
    void itCountsNumberOfTreeEncountered() {
      when(mountainside.reachedBottom())
          // Allowing 4 moves before reaching bottom
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(false)
          .thenReturn(true);

      when(mountainside.move(anyInt(), anyInt()))
          // 2 trees encountered
          .thenReturn(Square.TREE)
          .thenReturn(Square.NO_TREE)
          .thenReturn(Square.TREE)
          .thenReturn(Square.NO_TREE);

      String result = day3.solvePart1();

      assertEquals(result, "2");
    }
  }

  @Nested
  class Part2 {

  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      MountainsideFactory mountainsideFactory = new MountainsideFactory();
      day3 = new Day3(mountainsideFactory);
    }

    @Test
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

      assertEquals("7", result);
    }

    @Test
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

      assertEquals("336", result);
    }
  }


}