package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.MockitoAnnotations;

class Day5Test {

  private Day5 day5;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    day5 = new Day5();
  }

  @Test
  void itComputesSeatId() {
    assertEquals(567, day5.computeSeatId("BFFFBBFRRR"));
    assertEquals(119, day5.computeSeatId("FFFBBBFRRR"));
    assertEquals(820, day5.computeSeatId("BBFFBBFRLL"));
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


    @Test
    @Disabled
    void part2_exampleFromTheProblemStatement() {
      day5.inputLines = List.of(
          "eyr:1972 cid:100",
          "hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926",
          "",
          "iyr:2019",
          "hcl:#602927 eyr:1967 hgt:170cm",
          "ecl:grn pid:012533040 byr:1946",
          "",
          "hcl:dab227 iyr:2012",
          "ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277",
          "",
          "hgt:59cm ecl:zzz",
          "eyr:2038 hcl:74454a iyr:2023",
          "pid:3556412378 byr:2007"
      );

      String result = day5.solvePart2();

      assertEquals("0", result);
    }

  }
}