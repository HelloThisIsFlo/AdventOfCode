package adventofcode.day3;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import org.junit.jupiter.api.Test;

class TreeMapTest {

  @Test
  void itParsesMapLines() {
    TreeMap treeMap = new TreeMap(List.of(
        "..##",
        "#..."
    ));

    assertEquals(Square.NO_TREE, treeMap.get(0, 0));
    assertEquals(Square.NO_TREE, treeMap.get(1, 0));
    assertEquals(Square.TREE, treeMap.get(2, 0));
    assertEquals(Square.TREE, treeMap.get(3, 0));

    assertEquals(Square.TREE, treeMap.get(0, 1));
    assertEquals(Square.NO_TREE, treeMap.get(1, 1));
    assertEquals(Square.NO_TREE, treeMap.get(2, 1));
    assertEquals(Square.NO_TREE, treeMap.get(3, 1));
  }

  @Test
  void itReturnsTheWidthOfTheMap() {
    TreeMap treeMap = new TreeMap(List.of(
        "..##",
        "#..."
    ));

    assertEquals(4, treeMap.getWidth());
  }

  @Test
  void itReturnsTheHeightOfTheMap() {
    TreeMap treeMap = new TreeMap(List.of(
        "..##",
        "#..."
    ));

    assertEquals(2, treeMap.getHeight());
  }
}