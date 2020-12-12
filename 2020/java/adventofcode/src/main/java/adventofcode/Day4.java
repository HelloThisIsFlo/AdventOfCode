package adventofcode;

import adventofcode.day4.EmptyLineGrouper;
import adventofcode.day4.PassportParser;
import adventofcode.day4.PassportValidator;

public class Day4 extends Day {

  private final EmptyLineGrouper emptyLineGrouper;
  private final PassportParser passportParser;
  private final PassportValidator passportValidator;

  public Day4(
      EmptyLineGrouper emptyLineGrouper,
      PassportParser passportParser,
      PassportValidator passportValidator) {
    super("day4.txt");
    this.emptyLineGrouper = emptyLineGrouper;
    this.passportParser = passportParser;
    this.passportValidator = passportValidator;
  }

  @Override
  public String solvePart1() {
    return Integer.toString(countNumberOfValidPassports());
  }

  public int countNumberOfValidPassports() {
    return (int)
        emptyLineGrouper
            .groupOnEmptyLines(inputLines)
            .stream()
            .map(passportParser::parse)
            .filter(passportValidator::isValid)
            .count();
  }

  @Override
  public String solvePart2() {
    return "";
  }
}
