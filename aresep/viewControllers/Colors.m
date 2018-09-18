//
//  Colors.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 23/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "Colors.h"

@implementation Colors

+ (UIColor*) navigationBarColor
{
    return [UIColor colorWithRed:18.0f/255.0f green:23.0f/255.0f blue:60.0f/255.0f alpha:1.0f];
}

+ (UIColor*)colorWithRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

@end
