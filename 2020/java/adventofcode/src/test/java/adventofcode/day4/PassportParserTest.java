package adventofcode.day4;

import static adventofcode.day4.dto.Passport.Field.BYR;
import static adventofcode.day4.dto.Passport.Field.ECL;
import static adventofcode.day4.dto.Passport.Field.HCL;
import static adventofcode.day4.dto.Passport.Field.HGT;
import static org.junit.jupiter.api.Assertions.assertEquals;

import adventofcode.day4.dto.Passport;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PassportParserTest {

  PassportParser parser;

  @BeforeEach
  void setUp() {
    parser = new PassportParser();
  }

  @Test
  void itParsesPassport() {
    String correctlyFormattedPassport =
        "ecl:gry hcl:#fffffd\nbyr:1937 hgt:183cm";

    Passport passport = parser.parse(correctlyFormattedPassport);

    assertEquals("gry", passport.get(ECL));
    assertEquals("#fffffd", passport.get(HCL));
    assertEquals("1937", passport.get(BYR));
    assertEquals("183cm", passport.get(HGT));
  }

}