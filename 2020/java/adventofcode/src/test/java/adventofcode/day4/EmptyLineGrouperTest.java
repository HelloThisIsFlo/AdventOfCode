package adventofcode.day4;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class EmptyLineGrouperTest {

  EmptyLineGrouper emptyLineGrouper;

  @BeforeEach
  void setUp() {
    emptyLineGrouper = new EmptyLineGrouper();
  }

  @Test
  void itGroupsSingleBlock() {
    var linesToGroup = List.of(
        "Block 1",
        "Block 1",
        "Block 1"
    );

    var grouped = emptyLineGrouper.groupOnEmptyLines(linesToGroup);

    assertEquals(
        List.of("Block 1\nBlock 1\nBlock 1"),
        grouped
    );
  }

  @Test
  void itGroupsTwoBlock() {
    var linesToGroup = List.of(
        "Block 1",
        "Block 1",
        "Block 1",
        "",
        "Block 2",
        "Block 2"
    );

    var grouped = emptyLineGrouper.groupOnEmptyLines(linesToGroup);

    assertEquals(
        List.of(
            "Block 1\nBlock 1\nBlock 1",
            "Block 2\nBlock 2"
        ),
        grouped
    );
  }

  @Test
  void itGroupsMultipleBlocks() {
    var linesToGroup = List.of(
        "Block 1",
        "Block 1",
        "Block 1",
        "",
        "Block 2",
        "Block 2",
        "",
        "Block 3",
        "Block 3",
        "Block 3",
        "Block 3",
        "Block 3",
        "",
        "Block 4",
        "Block 4"
    );

    var grouped = emptyLineGrouper.groupOnEmptyLines(linesToGroup);

    assertEquals(
        List.of(
            "Block 1\nBlock 1\nBlock 1",
            "Block 2\nBlock 2",
            "Block 3\nBlock 3\nBlock 3\nBlock 3\nBlock 3",
            "Block 4\nBlock 4"
        ),
        grouped
    );
  }
}