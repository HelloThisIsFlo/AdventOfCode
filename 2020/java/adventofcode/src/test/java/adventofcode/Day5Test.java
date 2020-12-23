package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;

class Day5Test {

  private Day5 day5;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.openMocks(this);
    day5 = new Day5();
  }

  @Test
  void itComputesSeatId() {
    assertEquals(567, day5.computeSeatId("BFFFBBFRRR"));
    assertEquals(119, day5.computeSeatId("FFFBBBFRRR"));
    assertEquals(820, day5.computeSeatId("BBFFBBFRLL"));
  }

  @Test
  void debug() {
    day5.solvePart2();
  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      day5 = new Day5();
    }


    @Test
    void part1_exampleFromTheProblemStatement() {
      day5.inputLines = List.of(
          "BFFFBBFRRR",
          "FFFBBBFRRR",
          "BBFFBBFRLL"
      );

      String result = day5.solvePart1();

      assertEquals("820", result);
    }

  }
}