package adventofcode;

import adventofcode.day2.PasswordValidator;
import adventofcode.day2.PasswordWithPolicyParser;
import adventofcode.day2.dto.PasswordWithPolicy;
import java.util.List;

public class Day2 extends Day {

  private final PasswordValidator passwordValidator;

  public Day2(PasswordValidator passwordValidator) {
    super("day2.txt");
    this.passwordValidator = passwordValidator;
  }

  @Override
  public String solvePart1() {
    List<PasswordWithPolicy> entries = parseInput(new PasswordWithPolicyParser());
    long amountOfValidPasswords = entries.stream().filter(passwordValidator::isValid).count();
    return Long.toString(amountOfValidPasswords);
  }

  @Override
  public String solvePart2() {
    return null;
  }

}
