package adventofcode.day2;

import adventofcode.day2.dto.PasswordWithPolicy;

public class PositionPasswordValidator implements PasswordValidator {

  @Override
  public boolean isValid(PasswordWithPolicy passwordWithPolicy) {
    int positionA = passwordWithPolicy.policy.paramA;
    int positionB = passwordWithPolicy.policy.paramB;
    char letter = passwordWithPolicy.policy.letter;
    String password = passwordWithPolicy.password;

    boolean letterPresentInPosA = password.charAt(positionA - 1) == letter;
    boolean letterPresentInPosB = password.charAt(positionB - 1) == letter;

    return (letterPresentInPosA && !letterPresentInPosB)
        || (!letterPresentInPosA && letterPresentInPosB);
  }
}
