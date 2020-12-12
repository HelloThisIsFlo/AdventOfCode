package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class EyrFieldValidatorTest extends FieldValidatorTest {

  public EyrFieldValidatorTest() {
    super(new EyrFieldValidator());
  }

  @Test
  void yearBetween2020And2030AndIs4Digits() {
    assertValid("2020");
    assertValid("2025");
    assertValid("2030");
  }

  @Test
  void yearIsNot4Digits() {
    assertInvalid("800");
    assertInvalid("12000");
  }

  @Test
  void yearLaterThan2030() {
    assertInvalid("2031");
    assertInvalid("2040");
  }

  @Test
  void yearEarlierThan2020() {
    assertInvalid("2019");
    assertInvalid("1000");
  }
}