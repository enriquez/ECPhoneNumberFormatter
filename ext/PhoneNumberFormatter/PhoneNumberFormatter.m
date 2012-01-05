#import "PhoneNumberFormatter.h"

@interface PhoneNumberFormatter(Private)
- (NSString *)parseString:(NSString *)input;
- (NSString *)parseStringStartingWithOne:(NSString *)input;
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
  } else if (len >= 4 && len <= 10) {
    [obj insertString:@"-" atIndex:3];
    output = obj;
  } else {
    output = obj;
  }
  
  return output;
}

- (NSString *)parseStringStartingWithOne:(NSString *)input
{
  NSMutableString *obj = [NSMutableString stringWithString:input];
  NSString *output;
  int len = input.length;
  
  if (len >= 2 && len <= 4) {
    NSMutableString *partialAreaCode = [NSMutableString stringWithString:[obj substringFromIndex:1]];
    int numSpaces = 3 - partialAreaCode.length;
    int i;
    for (i = 0; i < numSpaces; i++) {
      [partialAreaCode appendString:@" "];
    }
    output = [NSString stringWithFormat:@"1 (%@)", partialAreaCode];
  } else if (len >= 5 && len <= 7) {
    NSString *areaCode = [obj substringWithRange:NSMakeRange(1, 3)];
    NSString *rest = [obj substringFromIndex:4];
    output = [NSString stringWithFormat:@"1 (%@) %@", areaCode, rest];
  } else if (len >= 8 && len <= 11) {
    NSString *areaCode   = [obj substringWithRange:NSMakeRange(1, 3)];
    NSString *firstThree = [obj substringWithRange:NSMakeRange(4, 3)];
    NSString *rest = [obj substringFromIndex:7];
    output = [NSString stringWithFormat:@"1 (%@) %@-%@", areaCode, firstThree, rest];
  } else {
    output = obj;
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

