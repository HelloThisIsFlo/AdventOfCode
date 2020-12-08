package adventofcode.day2;

import static org.junit.jupiter.api.Assertions.*;

import adventofcode.day2.dto.PasswordWithPolicy;
import adventofcode.day2.dto.Policy;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

class PasswordWithPolicyParserTest {

  PasswordWithPolicyParser parser;

  @BeforeEach
  void setUp() {
    parser = new PasswordWithPolicyParser();
  }

  @Test
  void itParsesThePolicyAndPassword() {
    PasswordWithPolicy result = parser.parseLine("1-3 a: abcde");
    assertEquals(new Policy(1,3,'a'), result.policy);
    assertEquals("abcde", result.password);
  }

  @Test
  void itHandlesMultipleDigits() {
    PasswordWithPolicy result = parser.parseLine("1111-33333 a: abcde");
    assertEquals(new Policy(1111,33333,'a'), result.policy);
    assertEquals("abcde", result.password);
  }
}