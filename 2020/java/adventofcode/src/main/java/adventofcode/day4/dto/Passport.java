package adventofcode.day4.dto;

import java.util.HashMap;
import java.util.Map;
import org.apache.commons.lang3.builder.ToStringBuilder;

public class Passport {

  private final Map<Field, String> fieldsWithValues;

  public Passport() {
    fieldsWithValues = new HashMap<>();
  }


  public void set(Field field, String value) {
    fieldsWithValues.put(field, value);
  }

  public String get(Field field) {
    return fieldsWithValues.get(field);
  }

  public boolean has(Field field) {
    return fieldsWithValues.containsKey(field);
  }


  public enum Field {
    ECL("Eye Color"),
    PID("Pasport ID"),
    EYR("Expiration Year"),
    BYR("Birth Year"),
    IYR("Issue Year"),
    HCL("Hair Color"),
    CID("Country ID"),
    HGT("Height");

    private final String name;

    Field(String name) {
      this.name = name;
    }

    @Override
    public String toString() {
      // TODO: Check if that reads as well as expected
      return new ToStringBuilder(this)
          .append("name", name)
          .toString();
    }
  }
}
