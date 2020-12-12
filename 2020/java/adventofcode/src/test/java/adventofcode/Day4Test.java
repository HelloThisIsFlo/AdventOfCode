package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day4.EmptyLineGrouper;
import adventofcode.day4.PassportParser;
import adventofcode.day4.PassportValidator;
import adventofcode.day4.dto.Passport;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.InOrder;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class Day4Test {

  @Mock
  EmptyLineGrouper emptyLineGrouper;
  @Mock
  PassportParser passportParser;
  @Mock
  PassportValidator passportValidator;
  private Day4 day4;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    day4 = new Day4(emptyLineGrouper, passportParser, passportValidator);
  }


  @Nested
  class CountNumberOfValidPassports {

    @Test
    void itAsksInputSplitterToSplitInputOnEmptyLines() {
      day4.inputLines = List.of(
          "Block 1",
          "Block 1",
          "Block 1",
          "",
          "Block 2",
          "Block 2",
          "",
          "Block 3",
          "Block 3",
          "Block 3",
          "Block 3",
          "Block 3",
          "",
          "Block 4",
          "Block 4"
      );

      day4.countNumberOfValidPassports();

      verify(emptyLineGrouper).groupOnEmptyLines(List.of(
          "Block 1",
          "Block 1",
          "Block 1",
          "",
          "Block 2",
          "Block 2",
          "",
          "Block 3",
          "Block 3",
          "Block 3",
          "Block 3",
          "Block 3",
          "",
          "Block 4",
          "Block 4"
      ));
    }

    @Test
    void itParsesEachBlockToAPassport() {
      when(emptyLineGrouper.groupOnEmptyLines(any())).thenReturn(List.of(
          "Block1\nBlock1\nBlock1",
          "Block2\nBlock2",
          "Block3\nBlock3\nBlock3\nBlock3\nBlock3",
          "Block4\nBlock4"
      ));

      day4.countNumberOfValidPassports();

      InOrder inOrder = inOrder(passportParser);
      inOrder.verify(passportParser).parse("Block1\nBlock1\nBlock1");
      inOrder.verify(passportParser).parse("Block2\nBlock2");
      inOrder.verify(passportParser).parse("Block3\nBlock3\nBlock3\nBlock3\nBlock3");
      inOrder.verify(passportParser).parse("Block4\nBlock4");
    }

    @Test
    void itCountsTheNumberOfValidPassports() {
      when(emptyLineGrouper.groupOnEmptyLines(any())).thenReturn(List.of(
          "FAKE_PASSPORT_1",
          "FAKE_PASSPORT_2",
          "FAKE_PASSPORT_3",
          "FAKE_PASSPORT_4"
      ));
      when(passportParser.parse(anyString())).then(_invocation -> new Passport());
      when(passportValidator.isValid(any(Passport.class)))
          .thenReturn(true)
          .thenReturn(true)
          .thenReturn(false)
          .thenReturn(true);

      int numberOfValidPassports = day4.countNumberOfValidPassports();

      assertEquals(3, numberOfValidPassports);
    }
  }

  @Nested
  class Part2 {

  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      day4 = new Day4(
          new EmptyLineGrouper(),
          new PassportParser(),
          new PassportValidator()
      );
    }

    @Test
    void part1_exampleFromTheProblemStatement() {
      day4.inputLines = List.of(
          "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
          "byr:1937 iyr:2017 cid:147 hgt:183cm",
          "",
          "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
          "hcl:#cfa07d byr:1929",
          "",
          "hcl:#ae17e1 iyr:2013",
          "eyr:2024",
          "ecl:brn pid:760753108 byr:1931",
          "hgt:179cm",
          "",
          "hcl:#cfa07d eyr:2025 pid:166559648",
          "iyr:2011 ecl:brn hgt:59in"
      );

      String result = day4.solvePart1();

      assertEquals("2", result);
    }

    @Test
    @Disabled
    void part2_exampleFromTheProblemStatement() {
      day4.inputLines = List.of(
          "ecl:gry pid:860033327 eyr:2020 hcl:#fffffd",
          "byr:1937 iyr:2017 cid:147 hgt:183cm",
          "",
          "iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884",
          "hcl:#cfa07d byr:1929",
          "",
          "hcl:#ae17e1 iyr:2013",
          "eyr:2024",
          "ecl:brn pid:760753108 byr:1931",
          "hgt:179cm",
          "",
          "hcl:#cfa07d eyr:2025 pid:166559648",
          "iyr:2011 ecl:brn hgt:59in"
      );

      String result = day4.solvePart2();

      assertEquals("336", result);
    }
  }


}