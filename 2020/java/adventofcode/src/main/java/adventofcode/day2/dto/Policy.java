package adventofcode.day2.dto;

import java.util.Objects;

public class Policy {

  public final int paramA;
  public final int paramB;
  public final char letter;

  public Policy(int paramA, int paramB, char letter) {
    this.paramA = paramA;
    this.paramB = paramB;
    this.letter = letter;
  }

  @Override
  public boolean equals(Object o) {
    if (this == o) {
      return true;
    }
    if (o == null || getClass() != o.getClass()) {
      return false;
    }
    Policy that = (Policy) o;
    return paramA == that.paramA &&
        paramB == that.paramB &&
        Objects.equals(letter, that.letter);
  }

  @Override
  public int hashCode() {
    return Objects.hash(paramA, paramB, letter);
  }

  @Override
  public String toString() {
    return "PasswordPolicy{" +
        "paramA=" + paramA +
        ", paramB=" + paramB +
        ", letter='" + letter + '\'' +
        '}';
  }
}
