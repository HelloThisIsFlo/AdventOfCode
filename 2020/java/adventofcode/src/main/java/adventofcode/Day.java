package adventofcode;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.stream.Collectors;

public abstract class Day {

  List<String> inputLines;

  public Day(String puzzleInputFilename) {
    inputLines = readPuzzleInput(puzzleInputFilename);
  }

  private List<String> readPuzzleInput(String puzzleInputFilename) {
    Path puzzleInputPath = Paths.get(puzzleInputsFolder(), puzzleInputFilename);
    return tryToReadFile(puzzleInputPath);
  }

  protected String puzzleInputsFolder() {
    return "src/main/resources/puzzle_inputs/";
  }

  private List<String> tryToReadFile(Path filePath) {
    try {
      return Files.readAllLines(filePath);
    } catch (IOException e) {
      throw new IllegalStateException("File probably doesn't exist: " + filePath, e);
    }
  }

  protected <T> List<T> parseInput(InputParser<T> inputParser) {
    return inputLines
        .stream()
        .map(inputParser::parseLine)
        .collect(Collectors.toList());
  }

  abstract public String solvePart1();

  abstract public String solvePart2();

  public interface InputParser<T> {

    T parseLine(String line);
  }

}
