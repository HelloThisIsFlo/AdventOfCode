package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import adventofcode.common.EmptyLineGrouper;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class Day6Test {

  @Mock
  private EmptyLineGrouper emptyLineGrouper;
  private Day6 day6;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.openMocks(this);
    day6 = new Day6(emptyLineGrouper);
  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      emptyLineGrouper = new EmptyLineGrouper();
      day6 = new Day6(emptyLineGrouper);
    }


    @Test
    void part1_exampleFromTheProblemStatement() {
      day6.inputLines = List.of(
          "abc",
          "",
          "a",
          "b",
          "c",
          "",
          "ab",
          "ac",
          "",
          "a",
          "a",
          "a",
          "a",
          "",
          "b"
      );

      String result = day6.solvePart1();

      assertEquals("11", result);
    }

    @Test
    void part2_exampleFromTheProblemStatement() {
      day6.inputLines = List.of(
          "abc",
          "",
          "a",
          "b",
          "c",
          "",
          "ab",
          "ac",
          "",
          "a",
          "a",
          "a",
          "a",
          "",
          "b"
      );

      String result = day6.solvePart2();

      assertEquals("6", result);
    }

  }
}