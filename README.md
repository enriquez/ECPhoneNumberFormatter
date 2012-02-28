# PhoneNumberFormatter

NSFormatter subclass for phone numbers. Similar to iPhone's Phone app.

## Usage

Format a number

    PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
    NSString *formattedNumber = [formatter stringForObjectValue:@"2345677890"]
    // formattedNumber = @"(234) 567-7890"

Remove formatting

    PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
    id objectValue;
    NSError *error;
    [formatter getObjectValue:&objectValue forString:@"1 (234) 567-8900" errorDescription:&error];
    // objectValue = @"12345678900"

Format a NSTextField 

    PhoneNumberFormatter *formatter = [[PhoneNumberFormatter alloc] init];
    textField.cell.formatter = formatter;
    
    // textField.objectValue will be unformatted
    // textField.stringValue will be formatted