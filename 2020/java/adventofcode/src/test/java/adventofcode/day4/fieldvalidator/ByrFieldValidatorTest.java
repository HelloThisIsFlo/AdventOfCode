package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class ByrFieldValidatorTest extends FieldValidatorTest {

  public ByrFieldValidatorTest() {
    super(new ByrFieldValidator());
  }

  @Test
  void yearBetween1920And2020AndIs4Digits() {
    assertValid("1920");
    assertValid("1939");
    assertValid("2000");
    assertValid("2002");
  }

  @Test
  void yearIsNot4Digits() {
    assertInvalid("800");
    assertInvalid("12000");
  }

  @Test
  void yearLaterThan2002() {
    assertInvalid("2003");
    assertInvalid("2040");
  }

  @Test
  void yearEarlierThan1920() {
    assertInvalid("1919");
    assertInvalid("1000");
  }
}