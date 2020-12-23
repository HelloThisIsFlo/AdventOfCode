package adventofcode.day6;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

public class PersonAnswers {

  private final List<Answer> answers;

  public PersonAnswers(List<Answer> answers) {
    this.answers = answers;
  }

  public static PersonAnswers from(String personAnswersAsString) {
    String[] eachAnswersAsString = personAnswersAsString.split("");

    List<Answer> personAnswers =
        Arrays
            .stream(eachAnswersAsString)
            .map(String::toUpperCase)
            .map(Answer::valueOf)
            .collect(Collectors.toList());

    return new PersonAnswers(personAnswers);
  }

  public List<Answer> getAnswers() {
    return answers;
  }
}
