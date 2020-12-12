package adventofcode;

import adventofcode.day5.ColumnSeatTree;
import adventofcode.day5.RowSeatTree;
import adventofcode.day5.SeatTree;

public class Day5 extends Day {

  private final SeatTree rowSeatTree = new RowSeatTree(7);
  private final SeatTree columnSeatTree = new ColumnSeatTree(3);

  public Day5() {
    super("day5.txt");
  }

  @Override
  public String solvePart1() {
    return Integer.toString(
        inputLines
            .stream()
            .map(this::computeSeatId)
            .max(Integer::compareTo)
            .orElseThrow()
    );
  }

  @Override
  public String solvePart2() {
    return "";
  }

  public int computeSeatId(String seatQuery) {
    String rowSeatQuery = seatQuery.substring(0, 7);
    String columnSeatQuery = seatQuery.substring(7, 10);
    int row = rowSeatTree.valueAt(rowSeatQuery);
    int column = columnSeatTree.valueAt(columnSeatQuery);
    return row * 8 + column;
  }
}
