package adventofcode.day2;

import adventofcode.day2.dto.PasswordWithPolicy;
import adventofcode.day2.dto.Policy;
import java.util.Map;
import java.util.stream.Collectors;

public class MinMaxPasswordValidator implements PasswordValidator {

  @Override
  public boolean isValid(PasswordWithPolicy passwordWithPolicy) {
    String password = passwordWithPolicy.password;
    Policy policy = passwordWithPolicy.policy;

    if (!contains(password, policy.letter)) {
      return false;
    }

    Map<Integer, Long> letterCounts =
        password
            .chars()
            .boxed()
            .collect(Collectors.groupingBy(this::identity, Collectors.counting()));

    long occurrencesOfLetterToRepeat = letterCounts
        .getOrDefault((int) policy.letter, 0L);

    int minOccurrence = policy.paramA;
    int maxOccurrence = policy.paramB;
    return occurrencesOfLetterToRepeat >= minOccurrence
        && occurrencesOfLetterToRepeat <= maxOccurrence;
  }

  private <T> T identity(T obj) {
    return obj;
  }

  private boolean contains(String text, char candidate) {
    return text.indexOf(candidate) != -1;
  }
}
