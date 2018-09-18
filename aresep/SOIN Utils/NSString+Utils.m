//
//  NSString+Validation.m
//  PESSO
//
//  Created by Christopher Jimenez on 4/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSString+Utils.h"
#import <CommonCrypto/CommonDigest.h>

#pragma mark -

@implementation NSString(Utils)

- (BOOL) isValidEmail
{
	 NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"; 
     NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
    
    return [emailTest evaluateWithObject:self];
}

-(BOOL) isEmpty
{
    return (self.length == 0);
}


-(BOOL) isValidPhoneNumber
{

    return (self.length > 0);
}


-(BOOL) isValidPassword
{
    return (!self.isEmpty && self.length >= 6);
}




/////- (NSString *) stringByEscapingStringForUrl
////{
//
//    //NSString * escaptedString = (NSString *)CFURLCreateStringByAddingPercentEscapes(
//                                                    NULL,
//                                                    (CFStringRef)self,
//                                                    NULL,
//                                                    (CFStringRef)@"!*'();:@&=+$,/?%#[]",
//                                                    kCFStringEncodingUTF8 );
//    
//   // return escaptedString;
////}

- (NSString *) stringByTrimmingWhiteSpaces
{
    
    NSString *trimmedText = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    
    return trimmedText;
}

- (NSString *) stringByEscapingAmpersand
{
    NSString * escapedString = [self stringByReplacingOccurrencesOfString:@"&" withString:@"y"];
    
    return escapedString;
}

- (NSString *) stringByEscapingQuotes
{
    NSString * escapedString = [self stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    return escapedString;
}

- (NSString *) stringByEscapingSlash
{
    NSString * escapedString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"|" withString:@""];
    return escapedString;
}

- (NSString *) stringRemovingSpecialCharacters
{
    NSString * escapedString = [self stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"/" withString:@""];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"|" withString:@""];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    escapedString = [escapedString stringByReplacingOccurrencesOfString:@"&" withString:@"y"];
    escapedString = [escapedString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return escapedString;
}


-(BOOL) isNumber
{
    bool returnValue = YES;
    if(![self isEmpty])
    {
        NSString *numberRegex = @"^[0-9]+$"; 
        NSPredicate *numberTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", numberRegex]; 
    
        returnValue =  [numberTest evaluateWithObject:self];
    }
    else
    {
        returnValue =  NO;
    }
    
    return returnValue;
}


- (NSString*)MD5
{
    // Create pointer to the string as UTF8
    const char *ptr = [self UTF8String];
    
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    
    return output;
}

- (NSDate*)dateValue
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:en_US];
    
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];

    NSDate *myDate = [df dateFromString: self];
    return myDate;
}

- (NSDate*)dateValueWithFormat:(NSString *)format
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:en_US];
    
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [df setDateFormat:format];
    
    NSDate *myDate = [df dateFromString: self];
    return myDate;
}

- (NSString *) stringByTruncatingString:(int)size
{
    NSString * shortString  = self;
    if([self length] > size)
    {
        // define the range you're interested in
        NSRange stringRange = {0, MIN([self length], size)};
        
        // adjust the range to include dependent chars
        stringRange = [self rangeOfComposedCharacterSequencesForRange:stringRange];
        
        
        shortString = [self substringWithRange:stringRange];
        
        shortString = [shortString stringByAppendingString:@"..."];
    }
    return shortString;
}

-(NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding {
	return (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL,
                                                               (CFStringRef)self,
                                                               NULL,
                                                               (CFStringRef)@"!*'\"();:@&=+$,/?%#[]% ",
                                                               CFStringConvertNSStringEncodingToEncoding(encoding)));
}


-(NSString *) monetaryValue
{
    return [NSString stringWithFormat:@"₡%@", self];
}

- (BOOL) isAllDigits
{
    NSCharacterSet* nonNumbers = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    NSRange r = [self rangeOfCharacterFromSet: nonNumbers];
    return r.location == NSNotFound;
}

@end
