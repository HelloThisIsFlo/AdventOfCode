package adventofcode;

import adventofcode.common.EmptyLineGrouper;
import adventofcode.day6.Answer;
import adventofcode.day6.Group;
import java.util.Set;
import java.util.function.Function;

public class Day6 extends Day {

  private final EmptyLineGrouper emptyLineGrouper;

  public Day6(EmptyLineGrouper emptyLineGrouper) {
    super("day6.txt");
    this.emptyLineGrouper = emptyLineGrouper;
  }

  @Override
  public String solvePart1() {
    int sumOfUniqueAnswersInEachGroup =
        sumOfAnswersMatchingConditionInEachGroup(Group::computeUniqueAnswers);
    return Integer.toString(sumOfUniqueAnswersInEachGroup);
  }

  @Override
  public String solvePart2() {
    int sumOfAnswersInCommonInEachGroup =
        sumOfAnswersMatchingConditionInEachGroup(Group::computeAnswersInCommon);
    return Integer.toString(sumOfAnswersInCommonInEachGroup);
  }

  private int sumOfAnswersMatchingConditionInEachGroup(Function<Group, Set<Answer>> groupFnToProcessAnswers) {
    return emptyLineGrouper
        .groupOnEmptyLines(inputLines)
        .stream()
        .map(Group::from)
        .map(groupFnToProcessAnswers)
        .map(Set::size)
        .mapToInt(Integer::intValue)
        .sum();
  }

}
