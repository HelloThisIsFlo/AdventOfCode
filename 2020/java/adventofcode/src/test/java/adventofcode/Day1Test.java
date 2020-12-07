package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

class Day1Test {

  @Nested
  class Integration {

    @Test
    void exampleFromTheProblemStatement() {
      Day1 day1 = new Day1();
      String result = day1.solvePart1(
          "1721\n"
              + "979\n"
              + "366\n"
              + "299\n"
              + "675\n"
              + "1456"
      );

      assertEquals("514579", result);
    }
  }


}