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
import static org.mockito.ArgumentMatchers.any;
import static org.mockito.ArgumentMatchers.anyString;
import static org.mockito.Mockito.times;
import static org.mockito.Mockito.verify;
import static org.mockito.Mockito.when;

import adventofcode.day4.dto.Passport;
import adventofcode.day4.dto.Passport.Field;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;

class AdvancedPassportValidatorTest {

  PassportValidator passportValidator;
  @Mock
  FieldValidator fieldValidator;
  @Mock
  FieldValidatorFactory fieldValidatorFactory;

  @BeforeEach
  void setUp() {
    MockitoAnnotations.initMocks(this);
    passportValidator = new AdvancedPassportValidator(fieldValidatorFactory);
    when(fieldValidatorFactory.validatorFor(any(Field.class))).thenReturn(fieldValidator);
    when(fieldValidator.isValid(anyString())).thenReturn(true);
  }

  @Test
  void itMakesSureAllRequiredFieldsArePresent() {
    assertTrue(passportValidator.isValid(passportWithAllFields()));
    assertTrue(passportValidator.isValid(passportWithAllFieldsExceptCid()));
    assertFalse(passportValidator.isValid(passportWithAllFieldsExceptHgt()));
    assertFalse(passportValidator.isValid(passportWithAllFieldsExceptByr()));
  }

  @Test
  void itChecksThatEachRequiredFieldIsValid() {
    passportValidator.isValid(passportWithAllFields());

    int numOfRequiredFields = 7;
    verify(fieldValidator, times(numOfRequiredFields)).isValid(anyString());
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

  private Passport passportWithAllExceptCidHgtByr() {
    Passport passport = new Passport();
    passport.set(IYR, "some iyr");
    passport.set(EYR, "some eyr");
    passport.set(HCL, "some hcl");
    passport.set(ECL, "some ecl");
    passport.set(PID, "some pid");
    return passport;
  }

  @Test
  void allFieldsAreValid_passportIsValid() {
    when(fieldValidator.isValid(anyString()))
        .thenReturn(true);

    assertTrue(passportValidator.isValid(passportWithAllFields()));
  }

  @Test
  void anyOneFieldIsInvalid_passportIsInvalid() {
    when(fieldValidator.isValid(anyString()))
        .thenReturn(true)
        .thenReturn(true)
        .thenReturn(true)
        .thenReturn(false)
        .thenReturn(true)
        .thenReturn(true)
        .thenReturn(true);

    assertFalse(passportValidator.isValid(passportWithAllFields()));
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
}