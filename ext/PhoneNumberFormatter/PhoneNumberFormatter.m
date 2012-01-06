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
  if ([anObject length] < 1) return nil;
  
  NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
  NSString *unformatted = [[anObject componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
  NSString *firstNumber = [unformatted substringToIndex:1],
           *output;
  
  if ([firstNumber isEqualToString:@"1"]) {
    output = [self parseStringStartingWithOne:unformatted];
  } else {
    output = [self parseString:unformatted];
  }
  return output;
}

- (BOOL)getObjectValue:(id *)anObject forString:(NSString *)string errorDescription:(NSString **)error {
  NSCharacterSet *doNotWant = [NSCharacterSet characterSetWithCharactersInString:@"()- "];
  *anObject = (id)[[string componentsSeparatedByCharactersInSet: doNotWant] componentsJoinedByString: @""];
  
  return YES;
}

- (BOOL)isPartialStringValid:(NSString **)partialStringPtr proposedSelectedRange:(NSRangePointer)proposedSelRangePtr originalString:(NSString *)origString originalSelectedRange:(NSRange)origSelRange errorDescription:(NSString **)error
{
  if (origSelRange.location == 1 && origSelRange.length == 0 && [origString isEqualToString:@"1"]) {
    *partialStringPtr = [self stringForObjectValue:*partialStringPtr];
    *proposedSelRangePtr = NSMakeRange(4, 0);
    return NO;
  } else if (origSelRange.location == 5 && origSelRange.length == 0 && [[origString substringToIndex:1] isEqualToString:@"1"]) {
    *partialStringPtr = [self stringForObjectValue:*partialStringPtr];
    *proposedSelRangePtr = NSMakeRange(9, 0);
    return NO;
  } else if (origSelRange.length == 1 && [[origString substringFromIndex:origString.length - 1] isEqualToString:@")"]) { // attempting to delete a right parenthensis
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"(\\w)\\s{0,3}\\)$" options:NSRegularExpressionCaseInsensitive error:nil];
    
    NSRange matchRange = [regex rangeOfFirstMatchInString:origString options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, origString.length)];
    
    *partialStringPtr = [regex stringByReplacingMatchesInString:origString options:NSMatchingWithoutAnchoringBounds range:NSMakeRange(0, origString.length) withTemplate:@""];
    *proposedSelRangePtr = NSMakeRange(matchRange.location, 0);
    return NO;
  } else {
    return YES;
  }
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
  NSUInteger len = input.length;
  
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
  NSUInteger numSpaces = 3 - partialAreaCode.length, i;
  
  for (i = 0; i < numSpaces; i++) {
    [partialAreaCode appendString:@" "];
  }
  return [NSString stringWithFormat:@"1 (%@)", partialAreaCode];
}

- (NSString *)parseStringStartingWithOne:(NSString *)input {
  NSUInteger len = input.length;
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

