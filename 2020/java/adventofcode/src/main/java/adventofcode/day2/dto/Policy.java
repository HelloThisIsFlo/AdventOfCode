package adventofcode.day2.dto;

import java.util.Objects;

public class Policy {

  public final int minRepetition;
  public final int maxRepetition;
  public final String letterToRepeat;

  public Policy(int minRepetition, int maxRepetition, String letterToRepeat) {
    this.minRepetition = minRepetition;
    this.maxRepetition = maxRepetition;
    this.letterToRepeat = letterToRepeat;
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
    return minRepetition == that.minRepetition &&
        maxRepetition == that.maxRepetition &&
        Objects.equals(letterToRepeat, that.letterToRepeat);
  }

  @Override
  public int hashCode() {
    return Objects.hash(minRepetition, maxRepetition, letterToRepeat);
  }

  @Override
  public String toString() {
    return "PasswordPolicy{" +
        "minRepetition=" + minRepetition +
        ", maxRepetition=" + maxRepetition +
        ", letterToRepeat='" + letterToRepeat + '\'' +
        '}';
  }
}
