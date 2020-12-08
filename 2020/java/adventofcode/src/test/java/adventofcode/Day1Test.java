package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.Collections;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

class Day1Test {

  private Day1 day1;

  @BeforeEach
  void setUp() {
    day1 = new Day1();
  }

  @Nested
  class FindNumbersThatGiveASum {

    @Test
    void emptyList_returnEmpty() {
      var result = day1.findNnumbersThatSumToS(2, 2020, Collections.emptyList());
      assertTrue(result.isEmpty());
    }

    @Test
    void listWithNotEnoughElements_returnEmpty() {
      var result = day1.findNnumbersThatSumToS(2, 2020, List.of(1));
      assertTrue(result.isEmpty());
    }

    @Test
    void listWithEnoughElements_valid_returnResult() {
      List<Integer> result = day1.findNnumbersThatSumToS(2, 2020, List.of(1000, 1020))
          .orElseThrow();

      assertTrue(result.contains(1000));
      assertTrue(result.contains(1020));
    }

    @Test
    void listWithEnoughElements_invalid_returnEmpty() {
      var result = day1.findNnumbersThatSumToS(2, 2020, List.of(1, 2));
      assertTrue(result.isEmpty());
    }

    @Test
    void findFourNumbersThatGiveSum() {
      List<Integer> result = day1.findNnumbersThatSumToS(
          4,
          1234,
          List.of(
              723,
              132,
              17,
              56,
              300,
              455,
              746
          )
      ).orElseThrow();

      assertTrue(result.contains(132));
      assertTrue(result.contains(56));
      assertTrue(result.contains(300));
      assertTrue(result.contains(746));
    }
  }

  @Nested
  class Integration {

    @Test
    void part1_exampleFromTheProblemStatement() {
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

    @Test
    void part2_exampleFromTheProblemStatement() {
      day1.inputLines = List.of(
          "1721",
          "979",
          "366",
          "299",
          "675",
          "1456"
      );

      String result = day1.solvePart2();

      assertEquals("241861950", result);
    }
  }


}