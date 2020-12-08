package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;
import static org.junit.jupiter.api.Assertions.assertTrue;

import adventofcode.Day1.TwoNumbers;
import java.util.Collections;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

class Day1Test {

  private Day1 day1;

  @BeforeEach
  void setUp() {
    day1 = new Day1();
  }

  @Nested
  class Find2NumberThatGiveASum {

    @Test
    void emptyList_throwError() {
      assertThrows(IllegalStateException.class, () -> {
        day1.findTwoNumbersThatSumTo(2020, Collections.emptyList());
      });
    }

    @Test
    void listWithTwoElements_valid_returnResult() {
      TwoNumbers result = day1.findTwoNumbersThatSumTo(2020, List.of(1000, 1020));

      assertTrue(result.contains(1000));
      assertTrue(result.contains(1020));
    }

    @Test
    void listWithTwoElements_invalid_throwError() {
      assertThrows(IllegalStateException.class, () -> {
        day1.findTwoNumbersThatSumTo(2020, List.of(1, 2));
      });
    }
  }

  @Nested
  class Integration {

    @Test
    void exampleFromTheProblemStatement() {
      day1.inputLines = List.of(
          "1721",
          "979",
          "366",
          "299",
          "675",
          "1456"
      );

      String result = day1.solvePart1();

      assertEquals("514579", result);
    }
  }


}