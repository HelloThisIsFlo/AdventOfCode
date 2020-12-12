package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;
import java.util.regex.Pattern;

public class HclFieldValidator implements FieldValidator {

  @Override
  public boolean isValid(String fieldValue) {
    return Pattern
        .compile("#[a-f0-9]{6}")
        .matcher(fieldValue)
        .matches();
  }
}