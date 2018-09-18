//
//  UILabel+Utils.m
//  TicoExpress
//
//  Created by Christopher Jimenez on 9/24/12.
//
//

#import "UILabel+Utils.h"

@implementation UILabel (Utils)

- (void) setVerticalAlignmentTop
{
    // TBK deprecated
    //CGSize textSize = [self.text sizeWithFont:self.font
    //                        constrainedToSize:self.frame.size
    //                            lineBreakMode:self.lineBreakMode];
    
    
    //CGRect textRect = CGRectMake(self.frame.origin.x,
    //                             self.frame.origin.y,
    //                             self.frame.size.width,
    //                             textSize.height);
    
    CGSize maximumLabelSize = CGSizeMake(self.frame.size.width, CGFLOAT_MAX);
    
    CGRect textRect = [self.text boundingRectWithSize:maximumLabelSize
                                             options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName:self.font}
                                             context:nil];
    
    
    [self setFrame:textRect];
    [self setNeedsDisplay];
}

@end
