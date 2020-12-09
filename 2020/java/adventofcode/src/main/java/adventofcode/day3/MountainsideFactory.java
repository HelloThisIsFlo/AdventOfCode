package adventofcode.day3;

import java.util.List;

public class MountainsideFactory {

  public Mountainside newMountainside(List<String> mapLines) {
    return new Mountainside(new TreeMap(mapLines));
  }

}
