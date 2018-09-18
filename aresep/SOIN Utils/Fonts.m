//
//  Fonts.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 26/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "Fonts.h"

@implementation Fonts

+ (UIFont*)regularFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Calibri" size:size];
}

+ (UIFont*)boldFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Calibri-Bold" size:size];
}

+ (UIFont*)italicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Calibri-Italic" size:size];
}


+ (UIFont*)boldItalicFontWithSize:(CGFloat)size
{
    return [UIFont fontWithName:@"Calibri-BoldItalic" size:size];
}



@end
