package adventofcode.day4;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

public class EmptyLineGrouper {


  public List<String> groupOnEmptyLines(List<String> inputWithEmptyLines) {
    BlockCollector blockCollector =
        inputWithEmptyLines
            .stream()
            .collect(
                BlockCollector::new,
                BlockCollector::onNewLine,
                BlockCollector::combine
            );

    blockCollector.completeBlockInProgress();

    return blockCollector.blocks
        .stream()
        .map(this::groupBlock)
        .collect(Collectors.toList());
  }

  private String groupBlock(List<String> block) {
    return String.join("\n", block);
  }


  private static class BlockCollector {

    public List<List<String>> blocks = new ArrayList<>();
    private List<String> blockInProgress;


    public void onNewLine(String line) {
      if (blockInProgress == null) {
        newBlockWith(line);
      } else {
        continueBlockInProgress(line);
      }
    }

    private void newBlockWith(String line) {
      blockInProgress = new ArrayList<>();
      blockInProgress.add(line);
    }

    private void continueBlockInProgress(String line) {
      boolean emptyLine = line.equals("");
      if (emptyLine) {
        completeBlockInProgress();
      } else {
        addToBlockInProgress(line);
      }
    }

    private void completeBlockInProgress() {
      blocks.add(blockInProgress);
      blockInProgress = null;
    }

    private void addToBlockInProgress(String line) {
      blockInProgress.add(line);
    }

    public void combine(BlockCollector other) {
      throw new RuntimeException("Support for parallel streams is not implemented");
    }

  }

}
