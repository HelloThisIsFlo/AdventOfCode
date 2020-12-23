package adventofcode.day6;

import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import java.util.stream.Stream;

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

  public Set<Answer> computeAnswersInCommon() {
    List<Answer> firstPersonAnswers = personAnswers.get(0).getAnswers();

    Stream<Answer> answersInCommon = firstPersonAnswers.stream();
    for (PersonAnswers personAnswer : personAnswers) {
      List<Answer> answers = personAnswer.getAnswers();
      answersInCommon = answersInCommon .filter(answers::contains);
    }

    return answersInCommon.collect(Collectors.toSet());
  }
}
