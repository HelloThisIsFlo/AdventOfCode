package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;

class Day6Test {

  private Day6 day6;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.openMocks(this);
    day6 = new Day6();
  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      day6 = new Day6();
    }


    @Test
    @Disabled
    void part1_exampleFromTheProblemStatement() {
      day6.inputLines = List.of(
          "BFFFBBFRRR",
          "FFFBBBFRRR",
          "BBFFBBFRLL"
      );

      String result = day6.solvePart1();

      assertEquals("820", result);
    }

  }
}