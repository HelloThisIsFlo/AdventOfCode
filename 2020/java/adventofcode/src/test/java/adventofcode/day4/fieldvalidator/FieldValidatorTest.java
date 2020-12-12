package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;
import org.junit.jupiter.api.Assertions;

public class FieldValidatorTest {

  private final FieldValidator validator;

  public FieldValidatorTest(FieldValidator validator) {
    this.validator = validator;
  }

  protected void assertInvalid(String fieldValue) {
    Assertions.assertFalse(validator.isValid(fieldValue));
  }

  protected void assertValid(String fieldValue) {
    Assertions.assertTrue(validator.isValid(fieldValue));
  }
}
