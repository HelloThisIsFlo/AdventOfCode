package adventofcode;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;

public class Day1 extends Day {

  private List<Integer> inputNumbers;

  public Day1() {
    super("day1.txt");
  }

  @Override
  public String solvePart1() {
    parseInputNumbers();

    return findNnumbersThatSumToS(2, 2020, inputNumbers)
        .map(this::multiplyAllNumbers)
        .map(Object::toString)
        .orElseThrow(() -> new IllegalStateException("Couldn't find 2 numbers that sum to 2020"));
  }

  @Override
  public String solvePart2() {
    parseInputNumbers();

    return findNnumbersThatSumToS(3, 2020, inputNumbers)
        .map(this::multiplyAllNumbers)
        .map(Object::toString)
        .orElseThrow(() -> new IllegalStateException("Couldn't find 3 numbers that sum to 2020"));
  }

  private void parseInputNumbers() {
    inputNumbers = parseInput(Integer::parseInt);
  }


  // Couldn't find a more readable way to write 'N numbers'
  @SuppressWarnings("SpellCheckingInspection")
  public Optional<List<Integer>> findNnumbersThatSumToS(int n, int s, List<Integer> candidates) {
    boolean notEnoughCandidates = candidates.size() < n;
    boolean lookingForASingleNumberThatEqualS = n == 1;

    if (notEnoughCandidates) {
      return Optional.empty();
    }
    if (lookingForASingleNumberThatEqualS) {
      return candidates.contains(s) ?
          Optional.of(mutableListWithOneElement(s)) :
          Optional.empty();
    }

    Integer first = candidates.get(0);
    List<Integer> candidatesWithoutFirst = copyWithoutFirst(candidates);

    Optional<List<Integer>> nMinus1numbersThatSumToSMinusFirst =
        findNnumbersThatSumToS(n - 1, s - first, candidatesWithoutFirst);

    return nMinus1numbersThatSumToSMinusFirst
        .map(result -> {
          result.add(first);
          return result;
        })
        .or(() -> findNnumbersThatSumToS(n, s, candidatesWithoutFirst));
  }

  private <T> List<T> mutableListWithOneElement(T element) {
    List<T> list = new ArrayList<>();
    list.add(element);
    return list;
  }

  private <T> List<T> copyWithoutFirst(List<T> list) {
    List<T> candidatesWithoutFirst = new ArrayList<>(list);
    candidatesWithoutFirst.remove(0);
    return candidatesWithoutFirst;
  }

  private Integer multiplyAllNumbers(List<Integer> numbers) {
    return numbers
        .stream()
        .reduce((i, j) -> i * j)
        .orElseThrow();
  }

}
