//
//  Bus_Routes+Category.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 03/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "Bus_Routes+Category.h"
#import "NSString+Utils.h"

@implementation Bus_Routes (Category)

- (BOOL)isValid
{
    BOOL response = YES;
    if ([self.regularFare isEmpty]) {
       response = NO;
    }
    return response;
}



@end
