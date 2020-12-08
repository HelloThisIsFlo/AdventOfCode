package adventofcode.day2;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import adventofcode.day2.dto.PasswordWithPolicy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PasswordValidatorTest {

  PasswordValidator validator;

  @BeforeEach
  void setUp() {
    validator = new PasswordValidator();
  }

  @Test
  void letterIsNotPresent_invalid() {
    assertFalse(
        validator.isValid(
            PasswordWithPolicy.of(1, 2, "a", "bcdef")
        )
    );
  }

  @Test
  void letterIsNotRepeatedEnough_invalid() {
    assertFalse(
        validator.isValid(
            PasswordWithPolicy.of(2, 8, "a", "abcde")
        )
    );
  }

  @Test
  void letterIsRepeatedTooMuchEnough_invalid() {
    assertFalse(
        validator.isValid(
            PasswordWithPolicy.of(2, 4, "a", "aaaaabcde")
        )
    );
  }

  @Test
  void letterIsRepeatedEnough_valid() {
    assertTrue(
        validator.isValid(
            PasswordWithPolicy.of(2, 4, "a", "aaabcde")
        )
    );
    assertTrue(
        validator.isValid(
            PasswordWithPolicy.of(2, 4, "a", "bcaaabcde")
        )
    );
    assertTrue(
        validator.isValid(
            PasswordWithPolicy.of(2, 4, "a", "aabcde")
        )
    );
    assertTrue(
        validator.isValid(
            PasswordWithPolicy.of(2, 4, "a", "aaaabcde")
        )
    );
  }
}