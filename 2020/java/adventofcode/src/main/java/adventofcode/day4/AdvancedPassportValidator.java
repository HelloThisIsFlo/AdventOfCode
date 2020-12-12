package adventofcode.day4;

import adventofcode.day4.dto.Passport;
import adventofcode.day4.dto.Passport.Field;

public class AdvancedPassportValidator extends PassportValidator {

  private final FieldValidatorFactory fieldValidatorFactory;

  public AdvancedPassportValidator(FieldValidatorFactory fieldValidatorFactory) {
    this.fieldValidatorFactory = fieldValidatorFactory;
  }

  @Override
  public boolean isValid(Passport passport) {
    boolean basicValidationPassed = super.isValid(passport);
    if (!basicValidationPassed) {
      return false;
    }

    for (Field field : REQUIRED_FIELDS) {
      var fieldValidator = fieldValidatorFactory.validatorFor(field);
      boolean fieldIsValid = fieldValidator.isValid(passport.get(field));
      if (!fieldIsValid) {
        return false;
      }
    }

    return true;
  }
}
