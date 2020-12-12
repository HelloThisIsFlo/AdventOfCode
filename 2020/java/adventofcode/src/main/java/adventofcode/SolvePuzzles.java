/*
 * This Java source file was generated by the Gradle 'init' task.
 */
package adventofcode;

import adventofcode.day2.MinMaxPasswordValidator;
import adventofcode.day2.PositionPasswordValidator;
import adventofcode.day3.MountainsideFactory;
import adventofcode.day4.EmptyLineGrouper;
import adventofcode.day4.PassportParser;
import adventofcode.day4.PassportValidator;
import java.util.List;

/*
Keeping this here in case I need to run a CLI at some point soon.
I haven't done java in a while so I'd rather have this around.
If I end up not using it, I'll delete 🙂👍
*/
public class SolvePuzzles {

  private final List<Day> daysToSolve;

  public SolvePuzzles() {
    daysToSolve = initializeDays();
  }

  private List<Day> initializeDays() {
    // Day 2
    MinMaxPasswordValidator minMaxPasswordValidator = new MinMaxPasswordValidator();
    PositionPasswordValidator positionPasswordValidator = new PositionPasswordValidator();

    // Day 3
    MountainsideFactory mountainsideFactory = new MountainsideFactory();

    // Day 4
    EmptyLineGrouper emptyLineGrouper = new EmptyLineGrouper();
    PassportParser passportParser = new PassportParser();
    PassportValidator passportValidator = new PassportValidator();

    return List.of(
        new Day1(),
        new Day2(minMaxPasswordValidator, positionPasswordValidator),
        new Day3(mountainsideFactory),
        new Day4(emptyLineGrouper, passportParser, passportValidator)
    );
  }

  public static void main(String[] args) {
    new SolvePuzzles().main();
  }

  private void main() {
    daysToSolve.forEach(day -> {
      System.out.println("--------------------------------------");
      System.out.println("Solving " + day.getClass().getName());

      String part1Result = day.solvePart1();
      System.out.println("Part 1: " + part1Result);

      String part2Result = day.solvePart2();
      System.out.println("Part 2: " + part2Result);

      System.out.println("--------------------------------------");
      System.out.println();
    });
  }

}
