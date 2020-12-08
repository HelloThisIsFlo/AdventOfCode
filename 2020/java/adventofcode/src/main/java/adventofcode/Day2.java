package adventofcode;

import adventofcode.day2.MinMaxPasswordValidator;
import adventofcode.day2.PasswordValidator;
import adventofcode.day2.PasswordWithPolicyParser;
import adventofcode.day2.PositionPasswordValidator;
import adventofcode.day2.dto.PasswordWithPolicy;
import java.util.List;

public class Day2 extends Day {

  private final PasswordValidator minMaxPasswordValidator;
  private final PasswordValidator positionPasswordValidator;

  public Day2(
      MinMaxPasswordValidator minMaxPasswordValidator,
      PositionPasswordValidator positionPasswordValidator
  ) {
    super("day2.txt");
    this.minMaxPasswordValidator = minMaxPasswordValidator;
    this.positionPasswordValidator = positionPasswordValidator;
  }

  @Override
  public String solvePart1() {
    return countNumberOfValidPasswordsInInput(minMaxPasswordValidator);
  }

  @Override
  public String solvePart2() {
    return countNumberOfValidPasswordsInInput(positionPasswordValidator);
  }

  private String countNumberOfValidPasswordsInInput(PasswordValidator passwordValidator) {
    List<PasswordWithPolicy> entries = parseInput(new PasswordWithPolicyParser());
    long amountOfValidPasswords = entries
        .stream()
        .filter(passwordValidator::isValid)
        .count();
    return Long.toString(amountOfValidPasswords);
  }

}
