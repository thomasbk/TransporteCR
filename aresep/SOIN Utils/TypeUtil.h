//
//  TypeUtil.h
//  PESSO
//
//  Created by Christopher Jimenez on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TypeUtil : NSObject


+(NSString *)toString:(id)value;

+(NSDate *)toDate:(id)value;

+(NSDate *)toDate:(id)value withFormat:(NSString *)format;

+(NSNumber *)toNumber:(id)value;

+(BOOL)toBOOL:(id)value;

+ (NSString *) boolToString:(BOOL)value;

+ (BOOL) isEmpty: (id) value;

+(BOOL)toBOOLFromHTMLCode:(id)value;

+(BOOL)toBOOLFromSuccessResponce:(id)value;

@end
