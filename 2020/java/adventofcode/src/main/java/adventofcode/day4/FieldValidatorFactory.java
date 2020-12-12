package adventofcode.day4;

import adventofcode.day4.dto.Passport.Field;
import adventofcode.day4.fieldvalidator.ByrFieldValidator;
import adventofcode.day4.fieldvalidator.CidFieldValidator;
import adventofcode.day4.fieldvalidator.EclFieldValidator;
import adventofcode.day4.fieldvalidator.EyrFieldValidator;
import adventofcode.day4.fieldvalidator.HclFieldValidator;
import adventofcode.day4.fieldvalidator.HgtFieldValidator;
import adventofcode.day4.fieldvalidator.IyrFieldValidator;
import adventofcode.day4.fieldvalidator.PidFieldValidator;

public class FieldValidatorFactory {

  public FieldValidator validatorFor(Field field) {
    return switch (field) {
      case BYR -> new ByrFieldValidator();
      case CID -> new CidFieldValidator();
      case ECL -> new EclFieldValidator();
      case EYR -> new EyrFieldValidator();
      case HCL -> new HclFieldValidator();
      case HGT -> new HgtFieldValidator();
      case IYR -> new IyrFieldValidator();
      case PID -> new PidFieldValidator();
    };
  }
}
