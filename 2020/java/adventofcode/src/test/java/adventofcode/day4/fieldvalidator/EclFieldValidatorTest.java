package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class EclFieldValidatorTest extends FieldValidatorTest {

  public EclFieldValidatorTest() {
    super(new EclFieldValidator());
  }

  @Test
  void validEyeColor_valid() {
    assertValid("amb");
    assertValid("blu");
    assertValid("brn");
    assertValid("gry");
    assertValid("grn");
    assertValid("hzl");
    assertValid("oth");
  }

  @Test
  void invalidEyeColor_invalid() {
    assertInvalid("abc");
    assertInvalid("asdf");
  }
}