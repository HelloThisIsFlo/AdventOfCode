package adventofcode.day2;

import adventofcode.day2.dto.PasswordWithPolicy;
import adventofcode.day2.dto.Policy;
import java.util.Map;
import java.util.stream.Collectors;

public class PasswordValidator {

  public boolean isValid(PasswordWithPolicy passwordWithPolicy) {
    String password = passwordWithPolicy.password;
    Policy policy = passwordWithPolicy.policy;

    if (!password.contains(policy.letterToRepeat)) {
      return false;
    }

    Map<Integer, Long> letterCounts =
        password
            .chars()
            .boxed()
            .collect(Collectors.groupingBy(this::identity, Collectors.counting()));

    long occurrencesOfLetterToRepeat = letterCounts
        .getOrDefault(policy.letterToRepeat.codePointAt(0), 0L);

    return occurrencesOfLetterToRepeat >= policy.minRepetition
        && occurrencesOfLetterToRepeat <= policy.maxRepetition;
  }

  private <T> T identity(T obj) {
    return obj;
  }

}
