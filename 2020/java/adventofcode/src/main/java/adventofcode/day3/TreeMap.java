package adventofcode.day3;

import java.util.List;

public class TreeMap {

  List<String> mapLines;

  public TreeMap(List<String> mapLines) {
    this.mapLines = mapLines;
  }

  public Square get(int x, int y) {
    String mapLine = mapLines.get(y);
    return switch (mapLine.charAt(x)) {
      case '.' -> Square.NO_TREE;
      case '#' -> Square.TREE;
      default -> throw new IllegalStateException("Invalid mapLines");
    };
  }

  public int getWidth() {
    return mapLines.get(0).length();
  }

  public int getHeight() {
    return mapLines.size();
  }
}
