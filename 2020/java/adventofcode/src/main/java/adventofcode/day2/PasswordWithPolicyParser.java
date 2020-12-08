package adventofcode.day2;

import static com.google.common.base.Preconditions.checkNotNull;

import adventofcode.Day;
import adventofcode.day2.dto.PasswordWithPolicy;
import adventofcode.day2.dto.Policy;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class PasswordWithPolicyParser implements Day.InputParser<PasswordWithPolicy> {

  @Override
  public PasswordWithPolicy parseLine(String line) {
    LineRegexp lineRegexp = new LineRegexp(line);
    return new PasswordWithPolicy(
        new Policy(
            lineRegexp.getMinRepetition(),
            lineRegexp.getMaxRepetition(),
            lineRegexp.getLetterToRepeat()),
        lineRegexp.getPassword());
  }


  static class LineRegexp {

    private final Matcher matcher;

    public LineRegexp(String line) {
      Pattern pattern = Pattern
          .compile("(?<min>\\d+)-(?<max>\\d+) (?<letter>[a-z]): (?<password>[a-z]*)");

      matcher = pattern.matcher(line);

      boolean matchingSucceeded = matcher.find();
      if (!matchingSucceeded) {
        throw new IllegalStateException("Could not parse line: '" + line + "'");
      }
    }

    public int getMinRepetition() {
      return getIntValue("min");
    }

    public int getMaxRepetition() {
      return getIntValue("max");

    }

    public String getLetterToRepeat() {
      return getStringValue("letter");
    }

    public String getPassword() {
      return getStringValue("password");
    }

    private int getIntValue(String groupName) {
      return Integer.parseInt(getStringValue(groupName));
    }

    private String getStringValue(String groupName) {
      return checkNotNull(matcher.group(groupName));
    }
  }
}
