package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;
import java.util.regex.Pattern;

public class PidFieldValidator implements FieldValidator {

  @Override
  public boolean isValid(String fieldValue) {
    return Pattern.compile("0*\\d{9}").matcher(fieldValue).matches();
  }
}
