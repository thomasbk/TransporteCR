//
//  NSString+Validation.h
//  PESSO
//
//  Created by Christopher Jimenez on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(Utils)

- (BOOL) isValidEmail;

- (BOOL) isValidPhoneNumber;

- (BOOL) isValidPassword;

- (BOOL) isEmpty;

//- (NSString *) stringByEscapingStringForUrl;

- (NSString *) stringByEscapingAmpersand;

- (NSString *) stringByEscapingSlash;

- (NSString *) stringByEscapingQuotes;

- (NSString *) stringByTrimmingWhiteSpaces;

- (NSString *) stringRemovingSpecialCharacters;

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;

- (BOOL) isNumber;

- (NSString*)MD5;

- (NSDate*)dateValue;

- (NSDate*)dateValueWithFormat:(NSString *)format;

- (NSString *)stringByTruncatingString:(int)size;

- (NSString *) monetaryValue;

- (BOOL) isAllDigits;

@end
