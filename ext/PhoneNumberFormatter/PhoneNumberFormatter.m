#import "PhoneNumberFormatter.h"

@interface PhoneNumberFormatter(Private)
- (NSString *)parseString:(NSString *)input;
- (NSString *)parseStringStartingWithOne:(NSString *)input;
- (NSString *)parsePartialStringStartingWithOne:(NSString *)input;
- (NSString *)parseLastSevenDigits:(NSString *)basicNumber;
@end

@implementation PhoneNumberFormatter

- (NSString *)stringForObjectValue:(id)anObject {
  if (![anObject isKindOfClass:[NSString class]]) return nil;
  
  NSString *firstNumber       = [anObject substringToIndex:1],
           *unformattedString = [NSString stringWithString:anObject],
           *output;
  
  if ([firstNumber isEqualToString:@"1"]) {
    output = [self parseStringStartingWithOne:anObject];
  } else {
    output = [self parseString:anObject];
  }
  return output;
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
  NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
  *anObject = [[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
  
  return YES;
}

- (NSString *)parseLastSevenDigits:(NSString *)input {
  NSString *output;
  NSMutableString *obj = [NSMutableString stringWithString:input];
  
  if ([obj length] >= 4 && [obj length] <= 7) {
    [obj insertString:@"-" atIndex:3];
    output = obj;
  } else {
    output = obj;
  }
  return output;
}

- (NSString *)parseString:(NSString *)input {
  NSMutableString *obj = [NSMutableString stringWithString:input];
  NSString *output;
  int len = input.length;
  
  if (len >= 8 && len <= 10) {
    NSString *areaCode  = [obj substringToIndex:3]; 
    NSString *lastSeven = [self parseLastSevenDigits:[obj substringFromIndex:3]]; 
    output = [NSString stringWithFormat:@"(%@) %@", areaCode, lastSeven];
  } else if (len <= 10) {
    output = [self parseLastSevenDigits:obj];
  } else {
    output = obj;
  }
  return output;
}

- (NSString *)parsePartialStringStartingWithOne:(NSString *)input {
  NSMutableString *partialAreaCode = [NSMutableString stringWithString:[input substringFromIndex:1]];
  int numSpaces = 3 - partialAreaCode.length, i;
  
  for (i = 0; i < numSpaces; i++) {
    [partialAreaCode appendString:@" "];
  }
  return [NSString stringWithFormat:@"1 (%@)", partialAreaCode];
}

- (NSString *)parseStringStartingWithOne:(NSString *)input {
  int len = input.length;
  NSString *output;
  
  if (len == 1 || len >= 12) {
    output = input;
  } else if (len > 4) {
    NSString *firstPart  = [self parsePartialStringStartingWithOne:[input substringToIndex:4]];
    NSString *secondPart = [self parseLastSevenDigits:[input substringFromIndex:4]];
    output = [NSString stringWithFormat:@"%@ %@", firstPart, secondPart];
  } else {
    output = [NSString stringWithFormat:@"%@", [self parsePartialStringStartingWithOne:input]];
  }
  
  return output;
}

@end

void
Init_PhoneNumberFormatter(void)
{
  // Do nothing. This function is required by the MacRuby runtime when this
  // file is compiled as a C extension bundle.
}

