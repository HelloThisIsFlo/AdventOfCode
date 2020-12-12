package adventofcode.day4;

import adventofcode.day4.dto.Passport;
import adventofcode.day4.dto.Passport.Field;
import java.util.List;

public class PassportValidator {

  public static final List<Field> REQUIRED_FIELDS = List.of(
      Field.BYR,
      Field.IYR,
      Field.EYR,
      Field.HGT,
      Field.HCL,
      Field.ECL,
      Field.PID
  );

  public boolean isValid(Passport passport) {
    return REQUIRED_FIELDS
        .stream()
        .allMatch(passport::has);
  }

}
