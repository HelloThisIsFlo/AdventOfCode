package adventofcode.day2.dto;

import java.util.Objects;

public class PasswordWithPolicy {

  public final Policy policy;
  public final String password;

  public PasswordWithPolicy(Policy policy, String password) {
    this.policy = policy;
    this.password = password;
  }

  public static PasswordWithPolicy of(
      int paramA,
      int paramB,
      char letter,
      String password) {
    return new PasswordWithPolicy(
        new Policy(paramA, paramB, letter),
        password
    );
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    PasswordWithPolicy passwordWithPolicy = (PasswordWithPolicy) o;
    return Objects.equals(policy, passwordWithPolicy.policy) &&
        Objects.equals(password, passwordWithPolicy.password);
  }

  @Override
  public int hashCode() {
    return Objects.hash(policy, password);
  }

  @Override
  public String toString() {
    return "Line{" +
        "policy=" + policy +
        ", password='" + password + '\'' +
        '}';
  }
}
