package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;
import java.util.List;

public class EclFieldValidator implements FieldValidator {

  public static final List<String> VALID_EYE_COLORS = List.of(
      "amb",
      "blu",
      "brn",
      "gry",
      "grn",
      "hzl",
      "oth"
  );

  @Override
  public boolean isValid(String fieldValue) {
    return VALID_EYE_COLORS.contains(fieldValue);
  }
}
