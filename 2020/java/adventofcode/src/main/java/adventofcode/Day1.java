package adventofcode;

import java.util.ArrayList;
import java.util.List;

public class Day1 extends Day {

  private List<Integer> inputNumbers;

  public Day1() {
    super("day1.txt");
  }

  @Override
  public String solvePart1() {
    parseInputNumbers();

    TwoNumbers numbersThatSumTo2020 = findTwoNumbersThatSumTo(2020, inputNumbers);

    Integer productOfBothNumbers = numbersThatSumTo2020.number1 * numbersThatSumTo2020.number2;
    return productOfBothNumbers.toString();
  }

  private void parseInputNumbers() {
    inputNumbers = parseInput(Integer::parseInt);
  }

  @Override
  public String solvePart2() {
    return null;
  }

  public TwoNumbers findTwoNumbersThatSumTo(int expectedSum, List<Integer> numbers) {
    if (numbers.size() <= 1) {
      throw new IllegalStateException(
          "Could not find two numbers which sum would be: " + expectedSum);
    }

    Integer candidate = numbers.get(0);
    List<Integer> rest = new ArrayList<>(numbers);
    rest.remove(0);

    for (Integer otherNumber : rest) {
      if (candidate + otherNumber == expectedSum) {
        return new TwoNumbers(candidate, otherNumber);
      }
    }

    return findTwoNumbersThatSumTo(expectedSum, rest);
  }

  static class TwoNumbers {

    public final Integer number1;
    public final Integer number2;

    public TwoNumbers(Integer number1, Integer number2) {
      this.number1 = number1;
      this.number2 = number2;
    }

    public boolean contains(Integer number) {
      return number.equals(number1) || number.equals(number2);
    }

    @Override
    public String toString() {
      return "TwoNumbers{" +
          "number1=" + number1 +
          ", number2=" + number2 +
          '}';
    }
  }
}
