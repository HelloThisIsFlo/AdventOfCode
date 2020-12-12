package adventofcode.day4;

import adventofcode.day4.dto.Passport;
import adventofcode.day4.dto.Passport.Field;

public class PassportParser {


  public Passport parse(String passportAsString) {
    String[] fieldsToParse = passportAsString.split("[ \\n]");

    Passport passport = new Passport();
    for (String fieldToParse : fieldsToParse) {
      String[] fieldKeyAndValueStrings = fieldToParse.split(":");
      String fieldKeyString = fieldKeyAndValueStrings[0];
      String fieldValue = fieldKeyAndValueStrings[1];

      passport.set(
          Field.valueOf(fieldKeyString.toUpperCase()),
          fieldValue
      );
    }

    return passport;
  }
}
