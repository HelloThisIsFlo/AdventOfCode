package adventofcode;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

public class Sandbox {

  public static void main(String[] args) {
    new Sandbox().main();
  }

  private void main() {

    printHelloWorldFile();
  }

  public void printHelloWorldFile() {
    var lines = readPuzzleInput("day1.txt");
    lines.forEach(System.out::println);
  }

  private List<String> readPuzzleInput(String filename) {
    Path puzzleInputPath = Paths.get("src/main/resources/puzzle_inputs/" + filename);
    try {
      return Files.readAllLines(puzzleInputPath);
    } catch (IOException e) {
      throw new IllegalStateException("File probably doesn't exist", e);
    }
  }

  public void printClassLoaders() {
    System.out.println("Classloader of this Sandbox:"
        + Sandbox.class.getClassLoader());

    System.out.println("Classloader of Logger:"
        + Logger.class.getClassLoader());

    System.out.println("Classloader of ArrayList:"
        + ArrayList.class.getClassLoader());
  }
}
