package adventofcode;

import adventofcode.day2.MinMaxPasswordValidator;
import adventofcode.day2.PasswordWithPolicyParser;
import adventofcode.day2.dto.PasswordWithPolicy;
import java.util.List;

public class Day2 extends Day {

  private final MinMaxPasswordValidator minMaxPasswordValidator;

  public Day2(MinMaxPasswordValidator minMaxPasswordValidator) {
    super("day2.txt");
    this.minMaxPasswordValidator = minMaxPasswordValidator;
  }

  @Override
  public String solvePart1() {
    List<PasswordWithPolicy> entries = parseInput(new PasswordWithPolicyParser());
    long amountOfValidPasswords = entries.stream().filter(minMaxPasswordValidator::isValid).count();
    return Long.toString(amountOfValidPasswords);
  }

  @Override
  public String solvePart2() {
    return null;
  }

}
