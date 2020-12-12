package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class HgtFieldValidator implements FieldValidator {

  @Override
  public boolean isValid(String fieldValue) {
    Pattern pattern = Pattern.compile("(?<value>\\d+)(?<unit>\\w\\w)");
    Matcher matcher = pattern.matcher(fieldValue);
    if (!matcher.find()) {
      return false;
    }

    String value = matcher.group("value");
    String unit = matcher.group("unit");
    return switch (unit) {
      case "cm" -> inRange(value, 150, 193);
      case "in" -> inRange(value, 59, 76);
      default -> false;
    };
  }

  private boolean inRange(String valueAsString, int min, int max) {
    int value = Integer.parseInt(valueAsString);
    return value >= min && value <= max;
  }
}
