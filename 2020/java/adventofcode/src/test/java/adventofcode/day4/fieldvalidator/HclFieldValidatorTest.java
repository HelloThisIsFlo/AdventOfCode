package adventofcode.day4.fieldvalidator;

import org.junit.jupiter.api.Test;

class HclFieldValidatorTest extends FieldValidatorTest {


  public HclFieldValidatorTest() {
    super(new HclFieldValidator());
  }

  @Test
  void correctFormat_valid() {
    assertValid("#abcd12");
    assertValid("#123456");
    assertValid("#abcdef");
  }

  @Test
  void letterNotInRangeAtoF_invalid() {
    String fieldWith5Chars = "#aaaaag";
    assertInvalid(fieldWith5Chars);
  }

  @Test
  void notEnoughChars_invalid() {
    String fieldWith5Chars = "#abcde";
    assertInvalid(fieldWith5Chars);
  }

  @Test
  void tooMuchChars_invalid() {
    String fieldWith7Chars = "#abcdefg";
    assertInvalid(fieldWith7Chars);
  }

  @Test
  void invalidChars_invalid() {
    assertInvalid("#aaaa!a");
  }

  @Test
  void missingHashtag_invalid() {
    assertInvalid("aaaaaa");
  }
}