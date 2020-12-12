package adventofcode.day4.fieldvalidator;

import adventofcode.day4.FieldValidator;

public class YearValidator implements FieldValidator {

  private final int minYear;
  private final int maxYear;

  public YearValidator(int minYear, int maxYear) {
    this.minYear = minYear;
    this.maxYear = maxYear;
  }

  @Override
  public boolean isValid(String fieldValue) {
    int year = Integer.parseInt(fieldValue);
    boolean yearLateEnough = year >= minYear;
    boolean yearSoonEnough = year <= maxYear;
    return yearLateEnough && yearSoonEnough;
  }
}
