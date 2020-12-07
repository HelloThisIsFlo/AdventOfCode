package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import org.junit.jupiter.api.Test;

class Day1Test {

  @Test
  void hello() {
    Day1 day1 = new Day1();

    var result = day1.hello("Frank");

    assertEquals("Hello Frank", result);
  }
}