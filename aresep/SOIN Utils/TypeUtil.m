//
//  TypeUtil.m
//  PESSO
//
//  Created by Christopher Jimenez on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TypeUtil.h"
#import "NSString+Utils.h"
@implementation TypeUtil


+ (NSString *) boolToString:(BOOL)value
{
    
    NSString * returnValue = @"No";
    if(value)
    {
        returnValue = @"Si";
    }
    
    return returnValue;
}

+ (BOOL) isEmpty: (id) value
{
    return value == nil
    
    || ([value isEqual:[NSNull null]]) //JS addition for coredata
    
    || ([value respondsToSelector:@selector(length)]
        
        && [(NSData *)value length] == 0)
    
    || ([value respondsToSelector:@selector(count)]
        
        && [(NSArray *)value count] == 0)
    
    || ([[value description] isEqualToString:@"<null>"]);
    
}

+(NSString *)toString:(id)value
{
    NSString * returnValue = @"";
    
    if ( [value isKindOfClass: [NSString class]] ) 
    {
        
        returnValue = value;
    }
    else if ( [value isKindOfClass: [NSNumber class]] )
    {
        returnValue = [value stringValue];
    }
    
    return returnValue;
}


+(NSNumber *)toNumber:(id)value
{
    NSNumber * returnValue = [NSNumber numberWithInt:0];
    
    if ( [value isKindOfClass: [NSString class]] )
    {
        NSNumberFormatter * f = [[NSNumberFormatter alloc] init];
        [f setNumberStyle:NSNumberFormatterDecimalStyle];
        returnValue = [f numberFromString:value];
    }

    if ( [value isKindOfClass: [NSNumber class]] )
    {
        returnValue = value;
    }
    
    return returnValue;
}


+(NSDate *)toDate:(id)value
{
    NSDate * returnValue = nil;
    
    if ( [value isKindOfClass: [NSDate class]] ) {
        
        returnValue = value;
    }
    else 
    {
        returnValue = [[self toString:value] dateValue];
    }
    
    return returnValue;
}

+(NSDate *)toDate:(id)value withFormat:(NSString *)format
{
    NSDate * returnValue = nil;
    
    if ( [value isKindOfClass: [NSDate class]] ) {
        
        returnValue = value;
    }
    else
    {
        returnValue = [[self toString:value] dateValueWithFormat:format];
    }
    
    return returnValue;
}

+(BOOL)toBOOL:(id)value
{
    BOOL returnValue = NO;
    
    if ( [value isKindOfClass: [NSNumber class]] ) {
        
        returnValue = [value boolValue];
    }
    else if ( [value isKindOfClass: [NSString class]] )
    {
       returnValue =  [(NSNumber *)value boolValue]; 
    }
    
    return returnValue;
}


+(BOOL)toBOOLFromHTMLCode:(id)value
{
    BOOL returnValue = NO;
    
    NSString * valueSt = [self toString:value];
        
    if([valueSt isEqualToString:@"200"])
    {
            returnValue = YES;
    }
        
    return returnValue;
}

+(BOOL)toBOOLFromSuccessResponce:(id)value
{
    BOOL returnValue = NO;
    
    NSString * valueSt = [self toString:value];
    
    if([valueSt isEqualToString:@"200"] || [valueSt isEqualToString:@"201"] || [valueSt isEqualToString:@"202"])
    {
        returnValue = YES;
    }
    
    return returnValue;
}


@end
