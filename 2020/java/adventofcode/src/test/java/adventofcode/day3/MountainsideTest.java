package adventofcode.day3;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.util.List;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Disabled;
import org.junit.jupiter.api.Test;

class MountainsideTest {

  Mountainside mountainside;

  @BeforeEach
  void setUp() {
    TreeMap treeMap = new TreeMap(List.of(
        "..##.......",
        "#...#...#..",
        "..##......."
    ));
    mountainside = new Mountainside(treeMap);
  }

  @Test
  void itStartsAt0x0y() {
    mountainside = new Mountainside(new TreeMap(List.of(
        "#....",
        ".....",
        ".....",
        ".....",
        "....."
    )));

    Square squareAtOrigin = mountainside.move(0, 0);

    assertEquals(squareAtOrigin, Square.TREE);
  }

  @Test
  void movesToTheCorrectSpot() {
    mountainside = new Mountainside(new TreeMap(List.of(
        ".....",
        "....#",
        ".....",
        ".....",
        "....."
    )));

    Square squareAt_4_1 = mountainside.move(4, 1);

    assertEquals(squareAt_4_1, Square.TREE);
  }

  @Test
  void keepsTrackOfPreviousPosition() {
    mountainside = new Mountainside(new TreeMap(List.of(
        ".....",
        ".....",
        ".....",
        "....#",
        "....."
    )));

    Square after1Move = mountainside.move(1, 2);
    Square after2Moves = mountainside.move(3, 1);

    assertEquals(after1Move, Square.NO_TREE);
    assertEquals(after2Moves, Square.TREE);
  }


  @Test
  void itWrapsWhenItReachesTheRightEdge() {
    mountainside = new Mountainside(new TreeMap(List.of(
        ".....",
        "#....",
        ".....",
        ".....",
        "....."
    )));

    Square squareWrappedBackAt_0_1 = mountainside.move(5, 1);

    assertEquals(squareWrappedBackAt_0_1, Square.TREE);
  }

  @Test
  void itWrapsMultipleTimesWhenItReachesTheRightEdge() {
    mountainside = new Mountainside(new TreeMap(List.of(
        ".....",
        "#....",
        ".....",
        ".....",
        "....."
    )));

    Square squareWrappedBackAt_0_1 = mountainside.move(15, 1);

    assertEquals(squareWrappedBackAt_0_1, Square.TREE);
  }

  @Test
  void itKeepsTrackOfWhenWeReachedBottom() {
    mountainside = new Mountainside(new TreeMap(List.of(
        ".....",
        "....#",
        ".....",
        ".....",
        "....."
    )));

    mountainside.move(1111, 1);
    assertFalse(mountainside.reachedBottom());

    mountainside.move(1111, 2);
    assertFalse(mountainside.reachedBottom());

    mountainside.move(1111, 1);
    assertTrue(mountainside.reachedBottom());
  }
}