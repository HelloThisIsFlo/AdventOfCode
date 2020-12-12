package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class HgtFieldValidatorTest extends FieldValidatorTest {

  HgtFieldValidatorTest() {
    super(new HgtFieldValidator());
  }

  @Test
  void noUnit_invalid() {
    assertInvalid("155");
    assertInvalid("not_even_a_number");
  }

  @Test
  void outOfRangeCm_invalid() {
    assertInvalid("149cm");
    assertInvalid("194cm");
  }

  @Test
  void outOfRangeIn_invalid() {
    assertInvalid("58in");
    assertInvalid("77cm");
  }

  @Test
  void inRangeCm_valid() {
    assertValid("150cm");
    assertValid("160cm");
    assertValid("193cm");
  }

  @Test
  void inRangeIn_valid() {
    assertValid("59in");
    assertValid("70in");

    assertValid("76in");
  }
}