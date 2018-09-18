//
//  RIButtonItem.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "RIButtonItem.h"

@implementation RIButtonItem
@synthesize label;
@synthesize action;

+(id)item
{
    return [[self new]autorelease];
}

+(id)itemWithLabel:(NSString *)inLabel
{
    id newItem = [self item];
    [newItem setLabel:inLabel];
    return newItem;
}
@end
