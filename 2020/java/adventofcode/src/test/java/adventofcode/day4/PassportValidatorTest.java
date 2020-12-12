package adventofcode.day4;

import static adventofcode.day4.dto.Passport.Field.BYR;
import static adventofcode.day4.dto.Passport.Field.CID;
import static adventofcode.day4.dto.Passport.Field.ECL;
import static adventofcode.day4.dto.Passport.Field.EYR;
import static adventofcode.day4.dto.Passport.Field.HCL;
import static adventofcode.day4.dto.Passport.Field.HGT;
import static adventofcode.day4.dto.Passport.Field.IYR;
import static adventofcode.day4.dto.Passport.Field.PID;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import adventofcode.day4.dto.Passport;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PassportValidatorTest {

  PassportValidator passportValidator;

  @BeforeEach
  void setUp() {
    passportValidator = new PassportValidator();
  }

  @Test
  void itValidatesPassports() {
    assertTrue(passportValidator.isValid(passportWithAllFields()));
    assertTrue(passportValidator.isValid(passportWithAllFieldsExceptCid()));
    assertFalse(passportValidator.isValid(passportWithAllFieldsExceptHgt()));
    assertFalse(passportValidator.isValid(passportWithAllFieldsExceptByr()));
  }

  private Passport passportWithAllFields() {
    Passport passport = passportWithAllFieldsExceptCid();
    passport.set(CID, "some cid");
    return passport;
  }

  private Passport passportWithAllFieldsExceptCid() {
    Passport passport = passportWithAllExceptCidHgtByr();
    passport.set(HGT, "some hgt");
    passport.set(BYR, "some byr");
    return passport;
  }

  private Passport passportWithAllFieldsExceptHgt() {
    Passport passport = passportWithAllExceptCidHgtByr();
    passport.set(CID, "some cid");
    passport.set(BYR, "some byr");
    return passport;
  }

  private Passport passportWithAllFieldsExceptByr() {
    Passport passport = passportWithAllExceptCidHgtByr();
    passport.set(CID, "some cid");
    passport.set(HGT, "some hgt");
    return passport;
  }

  private Passport passportWithAllExceptCidHgtByr() {
    Passport passport = new Passport();
    passport.set(IYR, "some iyr");
    passport.set(EYR, "some eyr");
    passport.set(HCL, "some hcl");
    passport.set(ECL, "some ecl");
    passport.set(PID, "some pid");
    return passport;
  }
}