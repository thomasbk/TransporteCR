//
//  Fonts.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 26/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Fonts : NSObject

+ (UIFont*)regularFontWithSize:(CGFloat)size;

+ (UIFont*)boldFontWithSize:(CGFloat)size;

+ (UIFont*)italicFontWithSize:(CGFloat)size;

+ (UIFont*)boldItalicFontWithSize:(CGFloat)size;

@end
