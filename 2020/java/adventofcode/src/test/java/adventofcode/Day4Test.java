package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.inOrder;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day4.AdvancedPassportValidator;
import adventofcode.common.EmptyLineGrouper;
import adventofcode.day4.FieldValidatorFactory;
import adventofcode.day4.PassportParser;
import adventofcode.day4.PassportValidator;
import adventofcode.day4.dto.Passport;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
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

  @Mock
  AdvancedPassportValidator advancedPassportValidator;
  private Day4 day4;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    day4 = new Day4(emptyLineGrouper, passportParser, passportValidator, null);
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

      day4.countNumberOfValidPassports(passportValidator);

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

      day4.countNumberOfValidPassports(passportValidator);

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

      int numberOfValidPassports = day4.countNumberOfValidPassports(passportValidator);

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
          new PassportValidator(),
          new AdvancedPassportValidator(
              new FieldValidatorFactory()
          )
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
    void part1_exampleFromTheProblemStatementCombinedWithArtificialInput() {
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
          "iyr:2011 ecl:brn hgt:59in",
          "",
          // This passport should be treated as valid for part 1, even though it's invalid for part 2
          "eyr:111 ecl:notacolor cid:129 byr:1989",
          "iyr:200 pid:896056539 hcl:#a97842 hgt:165cm"
      );

      String result = day4.solvePart1();

      assertEquals("3", result);
    }

    @Test
    void part2_exampleFromTheProblemStatement_1() {
      day4.inputLines = List.of(
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

      String result = day4.solvePart2();

      assertEquals("0", result);
    }

    @Test
    void part2_exampleFromTheProblemStatement_2() {
      day4.inputLines = List.of(
          "pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980",
          "hcl:#623a2f",
          "",
          "eyr:2029 ecl:blu cid:129 byr:1989",
          "iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm",
          "",
          "hcl:#888785",
          "hgt:164cm byr:2001 iyr:2015 cid:88",
          "pid:545766238 ecl:hzl",
          "eyr:2022",
          "",
          "iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719"
      );

      String result = day4.solvePart2();

      assertEquals("4", result);
    }
  }


}