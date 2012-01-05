#import "PhoneNumberFormatter.h"

@interface PhoneNumberFormatter(Private)
- (NSString *)parseString:(NSString *)input;
- (NSString *)parseStringStartingWithOne:(NSString *)input;
- (NSString *)parsePartialStringStartingWithOne:(NSString *)input;
- (NSString *)parseSevenDigitPhoneNumber:(NSString *)basicNumber;
@end

@implementation PhoneNumberFormatter

- (NSString *)stringForObjectValue:(id)anObject
{
  if (![anObject isKindOfClass:[NSString class]]) {
    return nil;
  }
  
  NSString *firstNumber = [anObject substringToIndex:1];
  NSString *output     = nil;
  
  if ([firstNumber isEqualToString:@"1"]) {
    output = [self parseStringStartingWithOne:anObject];
  } else {
    output = [self parseString:anObject];
  }
  
  return output;
}

- (NSString *)parseSevenDigitPhoneNumber:(NSString *)basicNumber {
  NSString *output;
  NSMutableString *obj = [NSMutableString stringWithString:basicNumber];
  if ([obj length] >= 4 && [obj length] <= 7) {
    [obj insertString:@"-" atIndex:3];
    output = obj;
  } else {
    output = obj;
  }
  
  return output;
}

- (NSString *)parseString:(NSString *)input
{
  NSMutableString *obj = [NSMutableString stringWithString:input];
  NSString *output;
  int len = input.length;
  
  if (len >= 8 && len <= 10) {
    NSString *areaCode   = [obj substringToIndex:3];    
    NSString *firstThree = [obj substringWithRange:NSMakeRange(3, 3)];
    NSString *lastFour   = [obj substringFromIndex:6];
    output = [NSString stringWithFormat:@"(%@) %@-%@", areaCode, firstThree, lastFour];
  } else {
    output = [self parseSevenDigitPhoneNumber:obj];
  }
  
  return output;
}

- (NSString *)parsePartialStringStartingWithOne:(NSString *)input {
  NSMutableString *partialAreaCode = [NSMutableString stringWithString:[input substringFromIndex:1]];
  int numSpaces = 3 - partialAreaCode.length;
  int i;
  for (i = 0; i < numSpaces; i++) {
    [partialAreaCode appendString:@" "];
  }
  
  return [NSString stringWithFormat:@"1 (%@)", partialAreaCode];
}

- (NSString *)parseStringStartingWithOne:(NSString *)input {
  int len = input.length;
  NSString *output;
  
  if (len == 1 || len >= 12) {
    [self parseSevenDigitPhoneNumber:input];
  }
  else if (len > 4) {
    NSString *firstPart  = [self parsePartialStringStartingWithOne:[input substringToIndex:4]];
    NSString *secondPart = [self parseSevenDigitPhoneNumber:[input substringFromIndex:4]];
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

