package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class PidFieldValidatorTest extends FieldValidatorTest {

  public PidFieldValidatorTest() {
    super(new PidFieldValidator());
  }

  @Test
  void nineDigits_valid() {
    assertValid("123456789");
  }

  @Test
  void nineDigitsAndLeadingZeros_valid() {
    assertValid("000000123456789");
  }

  @Test
  void anythingElse_invalid() {
    assertInvalid("1234567890"); // 10 digits
    assertInvalid("asdf");
  }
}