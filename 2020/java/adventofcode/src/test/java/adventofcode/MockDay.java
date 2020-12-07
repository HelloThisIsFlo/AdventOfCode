package adventofcode;

import java.util.List;

public class MockDay extends Day {

  private List<Integer> numbers;

  public MockDay() {
    super("day_mock.txt");
    numbers = parseInput(Integer::parseInt);
  }

  @Override
  protected String puzzleInputsFolder() {
    return "src/test/resources/puzzle_inputs/";
  }

  @Override
  public String solvePart1() {
    return numbers.stream()
        .reduce(0, Integer::sum)
        .toString();
  }

  @Override
  public String solvePart2() {
    return numbers.stream()
        .reduce(1, (i, j) -> i * j)
        .toString();
  }
}
