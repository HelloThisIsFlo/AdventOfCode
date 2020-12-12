package adventofcode.day5;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.IntStream;

public class SeatTree {

  private final int depth;
  private final Node rootNode;
  private final String leftCmd;
  private final String rightCmd;

  public SeatTree(int depth, String leftCmd, String rightCmd) {
    this.depth = depth;
    this.leftCmd = leftCmd;
    this.rightCmd = rightCmd;
    this.rootNode = buildTree();
  }

  private Node buildTree() {
    List<Node> leafNodes =
        IntStream
            .range(0, (int) Math.pow(2, depth))
            .mapToObj(ValueNode::new)
            .collect(Collectors.toList());

    return doBuildTree(leafNodes);
  }

  private Node doBuildTree(List<Node> nodes) {
    if (nodes.size() == 1) {
      return nodes.get(0);
    }

    List<Node> pathNodes = new ArrayList<>();
    for (int i = 0; i < nodes.size(); i = i + 2) {
      Node left = nodes.get(i);
      Node right = nodes.get(i + 1);
      pathNodes.add(new PathNode(left, right));
    }
    return doBuildTree(pathNodes);
  }

  public int valueAt(String rowQuery) {
    if (rowQuery.length() != depth) {
      throw new IllegalStateException("Row query is not the correct length!");
    }

    TreeWalker treeWalker = new TreeWalker();
    Arrays.stream(rowQuery.split("")).forEach(treeWalker::walk);
    return treeWalker.currentNode.value;
  }

  private static class Node {

    public final Node left;
    public final Node right;
    public final Integer value;

    private Node(Node left, Node right, Integer value) {
      this.left = left;
      this.right = right;
      this.value = value;
    }
  }

  private static class ValueNode extends Node {

    public ValueNode(int value) {
      super(null, null, value);
    }
  }

  private static class PathNode extends Node {

    public PathNode(Node left, Node right) {
      super(left, right, null);
    }
  }

  private class TreeWalker {

    private Node currentNode = rootNode;

    private void walk(String cmd) {
      currentNode = nextNode(cmd);
    }

    private Node nextNode(String cmd) {
      if (cmd.equals(leftCmd)) {
        return currentNode.left;
      }
      if (cmd.equals(rightCmd)) {
        return currentNode.right;
      }
      throw new IllegalStateException("Invalid row Query");
    }

  }

}
