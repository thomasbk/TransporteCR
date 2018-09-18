//
//  NSDate+Utils.m
//  PESSO
//
//  Created by Alex on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSDate+Utils.h"
#import <math.h>
@implementation NSDate(Utils)

-(BOOL)isToday
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    //tbk
    //NSDateComponents *components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSCalendarUnitDay) fromDate:[NSDate date]];
    
    NSDateComponents *components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:[NSDate date]];
    
    NSDate *today = [cal dateFromComponents:components];
    
    //tbk
    //components = [cal components:(NSEraCalendarUnit|NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit) fromDate:self];
    components = [cal components:(NSCalendarUnitEra|NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay) fromDate:self];
    
    NSDate *thisDate = [cal dateFromComponents:components];
    
    return [today isEqualToDate:thisDate];
}

-(NSString *)stringDateWithDefaultFormat
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd/MMM/yy"];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    [_formatter setLocale:usLocale];
    
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringDateWithServerFormat
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyyMMdd HH:mm"];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_ES"];
    [_formatter setLocale:usLocale];
    
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringDateWithFormat:(NSString *)format
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:format];
    
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringDateWithFormat:(NSString *)format andLocaleIdentifier:(NSString*)locale
{
    
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:format];
    
    NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:locale];
    [_formatter setLocale:usLocale];
    
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringYear
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"yyyy"];
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringMonth
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"MM"];
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;
}

-(NSString *)stringDay
{
    NSDateFormatter *_formatter=[[NSDateFormatter alloc] init];
    [_formatter setDateFormat:@"dd"];
    NSString * dateStr  = [_formatter stringFromDate:self];
    return dateStr;    
}

-(NSString *)getUTCFormateDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:en_US];
    
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    
    NSString *dateString = [df stringFromDate:self];
    return dateString;
}

-(NSString *)getUTCFormateTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:en_US];
    
    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    
    [df setDateFormat:@"hh:mm a"];
    
    NSString *dateString = [df stringFromDate:self];
    return dateString;
}

-(NSString *)getSystemTimeZoneFormateDate
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    NSLocale *en_US = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [df setLocale:en_US];
    
    [df setTimeZone:[NSTimeZone systemTimeZone]];
    
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss.S"];
    
    NSString *dateString = [df stringFromDate:self];
    return dateString;
}


+(NSString *)getTimeFromFloat:(float)hour shortFormat:(BOOL)format
{
    int num = (int)hour;
    
    float minutes = hour - num;
    
    int realMinutes = minutes * 60;
    
    if(realMinutes == 60)
    {
        realMinutes = 0;
        num++;
    }
    
    NSString * time = [NSString stringWithFormat:@"%d horas %d minutos",num,realMinutes];
    
    if(format)
    {
        time = [NSString stringWithFormat:@"%d:%dh",num,realMinutes];
    }
    
    return time; 
    
}


@end
