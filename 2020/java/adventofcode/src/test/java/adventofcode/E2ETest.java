package adventofcode;


import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

public class E2ETest {

  /*
  To test E2E the problem resolution framework, we use a MockDay which
  represents a fake problem where:
  - Part 1: is adding number found on the input lines
  - Part 2: is multiplying number found on the input lines

  The problem input is:

  1
  2

   */

  @Test
  void itReadsFromInputAndSolvesPart1() {
    Day mockDay = new MockDay();

    String result = mockDay.solvePart1();

    String expected = "3"; // 1 + 2 = 3
    assertEquals(expected, result);
  }

  @Test
  void itReadsFromInputAndSolvesPart2() {
    Day mockDay = new MockDay();

    String result = mockDay.solvePart2();

    String expected = "2"; // 1 * 2 = 2
    assertEquals(expected, result);
  }
}
