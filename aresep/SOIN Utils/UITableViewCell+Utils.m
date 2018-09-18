//
//  UITableViewCell+Utils.m
//  HorasSoin
//
//  Created by Alex on 5/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UITableViewCell+Utils.h"
#import <QuartzCore/QuartzCore.h>
#import "ColorMacros.h"

@implementation UITableViewCell(Utils)

-(void)setTransparentBackground
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor clearColor];
    self.backgroundView = backView;
    self.backgroundColor = [UIColor clearColor];
}

-(void)setClearOrGrayBackground:(BOOL)isGray
{
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    
    
     backView.backgroundColor = [UIColor clearColor];
        
    if (isGray) {
        //backView.backgroundColor = GENERAL_LIGHT_GRAY_COLOR;
    }
    
    self.backgroundView = backView;
    self.backgroundColor = [UIColor clearColor];
}


-(void)setClearCellStyle
{
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectZero];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.borderColor = [UIColor clearColor].CGColor;
    backView.layer.borderWidth = 2.0f;
    
    self.backgroundView = backView;
    self.backgroundColor = [UIColor whiteColor];

    
}

-(void)setAlternativeBackground:(int)cellIndex{

    if((cellIndex % 2) != 0)
    {
        //self.backgroundColor = CELL_LIGHT_BLUE;
    }
    else {
        
        self.backgroundColor = [UIColor whiteColor];
    }
    
}

@end
