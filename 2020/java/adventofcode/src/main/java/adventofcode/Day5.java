package adventofcode;

import adventofcode.day5.ColumnSeatTree;
import adventofcode.day5.RowSeatTree;
import adventofcode.day5.SeatPosition;
import adventofcode.day5.SeatTree;
import java.util.HashSet;
import java.util.Set;
import java.util.stream.Collectors;

public class Day5 extends Day {

  public static final int ROWS = 128;
  public static final int COLUMNS = 8;

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
    Set<SeatPosition> allSeat = generateAllSeatPositions();
    Set<SeatPosition> allSeatsInInput =
        inputLines
            .stream()
            .map(this::parseSeatQuery)
            .collect(Collectors.toSet());

    Set<SeatPosition> missingSeats = new HashSet<>(allSeat);
    missingSeats.removeAll(allSeatsInInput);

    Set<Integer> allSeatsInInputIds =
        allSeatsInInput
            .stream()
            .map(this::seatId)
            .collect(Collectors.toSet());

    Integer mySeatId = missingSeats.stream()
                                      .filter(seat -> {
                                        int seatId = seatId(seat);
                                        return allSeatsInInputIds.contains(seatId + 1)
                                               && allSeatsInInputIds.contains(seatId - 1);
                                      })
                                      .findFirst()
                                      .map(this::seatId)
                                      .orElseThrow();

    return mySeatId.toString();
  }

  private Set<SeatPosition> generateAllSeatPositions() {
    Set<SeatPosition> allSeatPositions = new HashSet<>(ROWS * COLUMNS);

    for (int rowIndex = 0; rowIndex < ROWS; rowIndex++) {
      for (int columnIndex = 0; columnIndex < COLUMNS; columnIndex++) {
        allSeatPositions.add(new SeatPosition(rowIndex, columnIndex));
      }
    }

    return allSeatPositions;
  }

  public int computeSeatId(String seatQuery) {
    return seatId(parseSeatQuery(seatQuery));
  }

  private int seatId(SeatPosition seat) {
    return seat.row * 8 + seat.column;
  }

  private SeatPosition parseSeatQuery(String seatQuery) {
    String rowSeatQuery = seatQuery.substring(0, 7);
    String columnSeatQuery = seatQuery.substring(7, 10);
    return new SeatPosition(
        rowSeatTree.valueAt(rowSeatQuery),
        columnSeatTree.valueAt(columnSeatQuery)
    );
  }
}
