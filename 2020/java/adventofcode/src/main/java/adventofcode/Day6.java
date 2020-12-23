package adventofcode;

import adventofcode.common.EmptyLineGrouper;
import adventofcode.day6.Group;
import java.util.Set;

public class Day6 extends Day {

  private final EmptyLineGrouper emptyLineGrouper;

  public Day6(EmptyLineGrouper emptyLineGrouper) {
    super("day6.txt");
    this.emptyLineGrouper = emptyLineGrouper;
  }

  @Override
  public String solvePart1() {
    int sumOfUniqueAnswersInEachGroup =
        emptyLineGrouper
            .groupOnEmptyLines(inputLines)
            .stream()
            .map(Group::from)
            .map(Group::computeUniqueAnswers)
            .map(Set::size)
            .mapToInt(Integer::intValue)
            .sum();

    return Integer.toString(sumOfUniqueAnswersInEachGroup);
  }

  @Override
  public String solvePart2() {
    return "";
  }

}
