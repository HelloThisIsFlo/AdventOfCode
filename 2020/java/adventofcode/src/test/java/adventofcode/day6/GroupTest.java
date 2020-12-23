package adventofcode.day6;

import static adventofcode.day6.Answer.*;
import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.util.List;
import java.util.Set;
import org.junit.jupiter.api.Nested;
import org.junit.jupiter.api.Test;

class GroupTest {

  @Nested
  class FromString {

    @Test
    void convertsFromSinglePerson() {
      Group groupWithSinglePerson = Group.from("abc");

      List<PersonAnswers> groupAnswers = groupWithSinglePerson.getPersonAnswers();

      assertEquals(1, groupAnswers.size());
      List<Answer> singlePersonAnswers = groupAnswers.get(0).getAnswers();
      assertThat(singlePersonAnswers).contains(A);
      assertThat(singlePersonAnswers).contains(Answer.B);
      assertThat(singlePersonAnswers).contains(Answer.C);
    }

    @Test
    void convertsFromMultiplePeople() {
      Group group = Group.from(
          "ab\n"
          + "bc\n"
          + "efg"
      );

      List<PersonAnswers> groupAnswers = group.getPersonAnswers();

      assertEquals(3, groupAnswers.size());

      List<Answer> personAnswers;
      personAnswers = groupAnswers.get(0).getAnswers();
      assertThat(personAnswers).contains(A);
      assertThat(personAnswers).contains(B);

      personAnswers = groupAnswers.get(1).getAnswers();
      assertThat(personAnswers).contains(B);
      assertThat(personAnswers).contains(C);

      personAnswers = groupAnswers.get(2).getAnswers();
      assertThat(personAnswers).contains(E);
      assertThat(personAnswers).contains(F);
      assertThat(personAnswers).contains(G);
    }
  }

  @Test
  void computeUniqueAnswers() {
    Group group = new Group(List.of(
        new PersonAnswers(List.of(A, B, C)),
        new PersonAnswers(List.of(D, E, F)),
        new PersonAnswers(List.of(B, C, H))
    ));


    assertEquals(Set.of(A, B, C, D, E, F, H), group.computeUniqueAnswers());
  }
}