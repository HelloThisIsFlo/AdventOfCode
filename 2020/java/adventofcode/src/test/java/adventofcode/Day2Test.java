package adventofcode;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day2.MinMaxPasswordValidator;
import adventofcode.day2.PositionPasswordValidator;
import adventofcode.day2.dto.PasswordWithPolicy;
import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class Day2Test {

  @Mock
  MinMaxPasswordValidator minMaxPasswordValidator;
  @Mock
  PositionPasswordValidator positionPasswordValidator;
  private Day2 day2;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    day2 = new Day2(minMaxPasswordValidator, positionPasswordValidator);
  }


  @Nested
  class Part1 {

    @Test
    void itVerifiesValidityOfPasswordUsingMinMaxPasswordValidator() {
      when(minMaxPasswordValidator.isValid(any())).thenReturn(true);
      day2.inputLines = List.of(
          "1-3 a: abcde",
          "1-3 b: cdefg",
          "2-9 c: ccccccccc"
      );

      day2.solvePart1();

      verify(minMaxPasswordValidator)
          .isValid(PasswordWithPolicy.of(1, 3, 'a', "abcde"));
      verify(minMaxPasswordValidator)
          .isValid(PasswordWithPolicy.of(1, 3, 'b', "cdefg"));
      verify(minMaxPasswordValidator)
          .isValid(PasswordWithPolicy.of(2, 9, 'c', "ccccccccc"));
    }

    @Test
    void itReturnsTheNumberOfValidPasswords() {
      when(minMaxPasswordValidator.isValid(any()))
          .thenReturn(true)
          .thenReturn(true)
          .thenReturn(false);
      day2.inputLines = List.of(
          "1-9 a: aaaaa", // Validation logic is mocked above, these are placeholder
          "1-9 a: aaaaa",
          "1-9 a: aaaaa"
      );

      String result = day2.solvePart1();

      assertEquals(result, "2");
    }
  }

  @Nested
  class Part2 {

    @Test
    void itVerifiesValidityOfPasswordUsingPositionPasswordValidator() {
      when(positionPasswordValidator.isValid(any())).thenReturn(true);
      day2.inputLines = List.of(
          "1-3 a: abcde",
          "1-3 b: cdefg",
          "2-9 c: ccccccccc"
      );

      day2.solvePart2();

      verify(positionPasswordValidator)
          .isValid(PasswordWithPolicy.of(1, 3, 'a', "abcde"));
      verify(positionPasswordValidator)
          .isValid(PasswordWithPolicy.of(1, 3, 'b', "cdefg"));
      verify(positionPasswordValidator)
          .isValid(PasswordWithPolicy.of(2, 9, 'c', "ccccccccc"));
    }

    @Test
    void itReturnsTheNumberOfValidPasswords() {
      when(positionPasswordValidator.isValid(any()))
          .thenReturn(true)
          .thenReturn(true)
          .thenReturn(false);
      day2.inputLines = List.of(
          "1-9 a: aaaaa", // Validation logic is mocked above, these are placeholder
          "1-9 a: aaaaa",
          "1-9 a: aaaaa"
      );

      String result = day2.solvePart2();

      assertEquals(result, "2");
    }
  }

  @Nested
  class Integration {

    @BeforeEach
    void setUp() {
      day2 = new Day2(
          new MinMaxPasswordValidator(),
          new PositionPasswordValidator()
      );
    }

    @Test
    void part1_exampleFromTheProblemStatement() {
      day2.inputLines = List.of(
          "1-3 a: abcde",
          "1-3 b: cdefg",
          "2-9 c: ccccccccc"
      );

      String result = day2.solvePart1();

      assertEquals("2", result);
    }

    @Test
    void part2_exampleFromTheProblemStatement() {
      day2.inputLines = List.of(
          "1-3 a: abcde",
          "1-3 b: cdefg",
          "2-9 c: ccccccccc"
      );

      String result = day2.solvePart2();

      assertEquals("1", result);
    }
  }


}