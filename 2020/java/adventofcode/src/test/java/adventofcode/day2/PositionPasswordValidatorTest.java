package adventofcode.day2;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import adventofcode.day2.dto.PasswordWithPolicy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class PositionPasswordValidatorTest {

  PasswordValidator validator;

  @BeforeEach
  void setUp() {
    validator = new PositionPasswordValidator();
  }

//  @Test
//  void letterPresentInOnePosition_valid() {
//    assertTrue(validator.isValid(
//        PasswordWithPolicy.of(1, 3, "a", "abcde")
//    ));
//
//    assertTrue(validator.isValid(
//        PasswordWithPolicy.of(1, 3, "a", "cbade")
//    ));
//  }
//
//  @Test
//  void letterMissingInBothPosition_invalid() {
//    assertFalse(validator.isValid(
//        PasswordWithPolicy.of(1, 3, "b", "cdefg")
//    ));
//  }
//
//  @Test
//  void letterPresentInBothPosition_invalid() {
//    assertFalse(validator.isValid(
//        PasswordWithPolicy.of(2, 9, "c", "cccccccccc")
//    ));
//  }
}