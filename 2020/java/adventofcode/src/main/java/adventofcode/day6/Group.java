package adventofcode.day6;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;

public class Group {

  private List<PersonAnswers> personAnswers;

  public Group(List<PersonAnswers> personAnswers) {
    this.personAnswers = personAnswers;
  }

  public static Group from(String groupString) {
    String[] allPersonAnswersAsString = groupString.split("\n");

    List<PersonAnswers> personAnswers =
        Arrays
            .stream(allPersonAnswersAsString)
            .map(PersonAnswers::from)
            .collect(Collectors.toList());

    return new Group(personAnswers);
  }

  public List<PersonAnswers> getPersonAnswers() {
    return personAnswers;
  }

  public Set<Answer> computeUniqueAnswers() {
    Set<Answer> uniqueAnswers = new HashSet<>();
    for (PersonAnswers personAnswer : personAnswers) {
      uniqueAnswers.addAll(personAnswer.getAnswers());
    }
    return uniqueAnswers;
  }
}
