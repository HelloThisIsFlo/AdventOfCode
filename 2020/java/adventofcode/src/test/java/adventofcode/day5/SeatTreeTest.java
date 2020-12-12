package adventofcode.day5;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;

import org.junit.jupiter.api.Test;

class SeatTreeTest {

  @Test
  void invalidQuery_tooDeep_throwError() {
    SeatTree treeWithDepth3 = new SeatTree(3, "F", "B");

    assertThrows(IllegalStateException.class, () -> {
      String queryTooDeep = "FFFF";
      treeWithDepth3.valueAt(queryTooDeep);
    });

    assertThrows(IllegalStateException.class, () -> {
      String queryNotDeepEnough = "FF";
      treeWithDepth3.valueAt(queryNotDeepEnough);
    });
  }

  @Test
  void treeWithDepth2() {
    SeatTree treeWithDepth2 = new SeatTree(2, "F", "B");

    assertEquals(0, treeWithDepth2.valueAt("FF"));
    assertEquals(1, treeWithDepth2.valueAt("FB"));
    assertEquals(2, treeWithDepth2.valueAt("BF"));
    assertEquals(3, treeWithDepth2.valueAt("BB"));
  }

  @Test
  void rowExampleFromProblemStatement() {
    SeatTree treeWithDepth7 = new SeatTree(7, "F", "B");
    assertEquals(44, treeWithDepth7.valueAt("FBFBBFF"));
  }

  @Test
  void columnExampleFromProblemStatement() {
    SeatTree treeWithDepth7 = new SeatTree(3, "L", "R");
    assertEquals(5, treeWithDepth7.valueAt("RLR"));
  }
}