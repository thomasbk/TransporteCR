//
//  UITableViewCell+Utils.h
//  HorasSoin
//
//  Created by Alex on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell(Utils)

-(void)setTransparentBackground;

-(void)setClearCellStyle;

-(void)setAlternativeBackground:(int)cellIndex;

-(void)setClearOrGrayBackground:(BOOL)isGray;

@end
