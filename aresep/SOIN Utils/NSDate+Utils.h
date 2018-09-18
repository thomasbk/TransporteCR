//
//  NSDate+Utils.h
//  PESSO
//
//  Created by Alex on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate(Utils)

-(BOOL)isToday;

-(NSString *)stringDateWithDefaultFormat;

-(NSString *)stringDateWithFormat:(NSString *)format;

-(NSString *)stringDateWithFormat:(NSString *)format andLocaleIdentifier:(NSString*)locale;

-(NSString *)stringYear;

-(NSString *)stringMonth;
 
-(NSString *)stringDay;

+(NSString *)getTimeFromFloat:(float)hour shortFormat:(BOOL)format;

-(NSString *)getUTCFormateDate;

-(NSString *)getUTCFormateTime;

-(NSString *)getSystemTimeZoneFormateDate;

-(NSString *)stringDateWithServerFormat;

@end
