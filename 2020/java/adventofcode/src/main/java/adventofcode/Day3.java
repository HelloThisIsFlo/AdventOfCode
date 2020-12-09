package adventofcode;

import adventofcode.day3.Mountainside;
import adventofcode.day3.MountainsideFactory;
import adventofcode.day3.Square;

public class Day3 extends Day {

  private final MountainsideFactory mountainsideFactory;

  public Day3(MountainsideFactory mountainsideFactory) {
    super("day3.txt");
    this.mountainsideFactory = mountainsideFactory;
  }

  @Override
  public String solvePart1() {
    int treesEncountered = findNumberOfTreesEncounteredBySlope(3, 1);
    return Integer.toString(treesEncountered);
  }

  private int findNumberOfTreesEncounteredBySlope(int slopeX, int slopeY) {
    Mountainside mountainside = mountainsideFactory.newMountainside(inputLines);
    int treesEncountered = 0;

    while (!mountainside.reachedBottom()) {
      Square square = mountainside.move(slopeX, slopeY);
      if (square == Square.TREE) {
        treesEncountered++;
      }
    }
    return treesEncountered;
  }

  @Override
  public String solvePart2() {
    int treesEncounteredInSlope1 = findNumberOfTreesEncounteredBySlope(1, 1);
    int treesEncounteredInSlope2 = findNumberOfTreesEncounteredBySlope(3, 1);
    int treesEncounteredInSlope3 = findNumberOfTreesEncounteredBySlope(5, 1);
    int treesEncounteredInSlope4 = findNumberOfTreesEncounteredBySlope(7, 1);
    int treesEncounteredInSlope5 = findNumberOfTreesEncounteredBySlope(1, 2);

    int productOfAllTreesEncountered =
        treesEncounteredInSlope1
            * treesEncounteredInSlope2
            * treesEncounteredInSlope3
            * treesEncounteredInSlope4
            * treesEncounteredInSlope5;

    return Integer.toString(productOfAllTreesEncountered);
  }
}
