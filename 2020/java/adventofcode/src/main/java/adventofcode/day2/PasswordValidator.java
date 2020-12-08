package adventofcode.day2;

import adventofcode.day2.dto.PasswordWithPolicy;

public interface PasswordValidator {

  boolean isValid(PasswordWithPolicy passwordWithPolicy);
}
