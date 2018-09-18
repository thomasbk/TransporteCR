//
//  NSNumber+Utils.m
//  Domicilio
//
//  Created by Christopher Jimenez on 7/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSNumber+Utils.h"

@implementation NSNumber(Utils)

-(NSString *) monetaryValue
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    //[formatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    
    [formatter setPositiveFormat:@"###,###,##0"];
    
    //formatter setNumberStyle:(NSNumberFormatterStyle)

    NSString * value = [formatter stringFromNumber:self];
    
    value = [NSString stringWithFormat:@"₡%@", value];
    return value;
}


@end
