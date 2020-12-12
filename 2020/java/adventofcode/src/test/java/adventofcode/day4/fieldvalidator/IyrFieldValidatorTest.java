package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class IyrFieldValidatorTest extends FieldValidatorTest {

  public IyrFieldValidatorTest() {
    super(new IyrFieldValidator());
  }

  @Test
  void yearBetween2010And2020AndIs4Digits() {
    assertValid("2010");
    assertValid("2014");
    assertValid("2020");
  }

  @Test
  void yearLaterThan2020() {
    assertInvalid("2021");
    assertInvalid("2040");
  }

  @Test
  void yearEarlierThan2010() {
    assertInvalid("2009");
  }

  @Test
  void yearIsNot4Digits() {
    assertInvalid("800");
    assertInvalid("12000");
  }
}