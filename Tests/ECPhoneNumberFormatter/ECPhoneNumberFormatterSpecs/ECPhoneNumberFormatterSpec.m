// ECPhoneNumberFormatterSpec.m
// ECPhoneNumberFormatter
//
// Copyright (c) 2013, Michael Enriquez (http://enriquez.me)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "Kiwi.h"
#import "ECPhoneNumberFormatter.h"

SPEC_BEGIN(ECPhoneNumberFormatterSpec)

describe(@"ECPhoneNumberFormatter", ^{
    __block ECPhoneNumberFormatter *phoneNumberFormatter;

    beforeEach(^{
        phoneNumberFormatter = [[ECPhoneNumberFormatter alloc] init];
    });

    describe(@"stringForObjectValue:", ^{
        it(@"returns nil string when empty string", ^{
            [[phoneNumberFormatter stringForObjectValue:@""] shouldBeNil];
        });

        it(@"handles non-numerical values", ^{
            [[phoneNumberFormatter stringForObjectValue:@"*"] shouldBeNil];
        });

        it(@"returns (234) 567-7890 for 2345677890", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"2345677890"] should] equal:@"(234) 567-7890"];
        });

        it(@"returns 1 for 1", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"1"] should] equal:@"1"];
        });

        it(@"returns 223-4 for 2234", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"2234"] should] equal:@"223-4"];
        });

        it(@"returns 223-45 for 22345", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"22345"] should] equal:@"223-45"];
        });

        it(@"returns (223) 456-78 for 22345678", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"22345678"] should] equal:@"(223) 456-78"];
        });

        it(@"returns 23456778909 for 23456778909", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"23456778909"] should] equal:@"23456778909"];
        });

        it(@"returns 223-4567 for 2234567", ^{
            [[[phoneNumberFormatter stringForObjectValue:@"2234567"] should] equal:@"223-4567"];
        });

        describe(@"starting with a 1", ^{
            it(@"returns 1 (2  ) for 12", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"12"] should] equal:@"1 (2  )"];
            });

            it(@"returns 1 (23 ) for 123", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"123"] should] equal:@"1 (23 )"];
            });

            it(@"returns 1 (234) for 1234", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"1234"] should] equal:@"1 (234)"];
            });

            it(@"returns 1 (234) 5 for 12345", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"12345"] should] equal:@"1 (234) 5"];
            });

            it(@"returns 1 (234) 567-8 for 12345678", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"12345678"] should] equal:@"1 (234) 567-8"];
            });

            it(@"returns 1 (234) 567-8900 for 12345678900", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"12345678900"] should] equal:@"1 (234) 567-8900"];
            });

            it(@"returns 1 (234) 567-8900 for 1 (2345) 678-900", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"1 (2345) 678-900"] should] equal:@"1 (234) 567-8900"];
            });

            it(@"returns 1 (234) 567-8900 for 1 234.567.8900", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"1 234.567.8900"] should] equal:@"1 (234) 567-8900"];
            });

            it(@"returns 123456789000 for 123456789000", ^{
                [[[phoneNumberFormatter stringForObjectValue:@"123456789000"] should] equal:@"123456789000"];
            });
        });
    });

    describe(@"getObjectValue:forString:errorDescription:", ^{
        __block id objectValue;
        __block NSString *error;

        beforeEach(^{
            objectValue = nil;
            error = nil;
        });

        it(@"returns 1 for 1", ^{
            [phoneNumberFormatter getObjectValue:&objectValue
                                       forString:@"1"
                                errorDescription:&error];
            [[objectValue should] equal:@"1"];
        });

        it(@"returns 12345678900 for 1 (234) 567-8900", ^{
            [phoneNumberFormatter getObjectValue:&objectValue
                                       forString:@"1 (234) 567-8900"
                                errorDescription:&error];
            [[objectValue should] equal:@"12345678900"];
        });
    });
});

SPEC_END
