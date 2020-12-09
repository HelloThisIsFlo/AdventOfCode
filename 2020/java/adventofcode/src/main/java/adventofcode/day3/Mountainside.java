package adventofcode.day3;

public class Mountainside {

  private final TreeMap treeMap;

  private int currentPosX = 0;
  private int currentPosY = 0;

  public Mountainside(TreeMap treeMap) {
    this.treeMap = treeMap;
  }

  public Square move(int xDelta, int yDelta) {
    currentPosX += xDelta;
    currentPosY += yDelta;

    wrapAroundIfNeeded();

    return treeMap.get(currentPosX, currentPosY);
  }

  private void wrapAroundIfNeeded() {
    while (currentPosX >= treeMap.getWidth()) {
      currentPosX -= treeMap.getWidth();
    }
  }

  public boolean reachedBottom() {
    return currentPosY >= treeMap.getHeight() - 1;

  }
}
