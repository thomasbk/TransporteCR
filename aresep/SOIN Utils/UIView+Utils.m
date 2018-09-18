//
//  UIView+Utils.m
//  TicoExpress
//
//  Created by Christopher Jimenez on 9/13/12.
//
//

#import "UIView+Utils.h"

@implementation UIView (Utils)


-(void) setHiddenWithAnimation:(BOOL)hidden
{
    
    [UIView animateWithDuration:0.3 animations:^() {
        if(hidden){
            self.alpha = 0.0;
        }
        else
        {
            self.alpha = 1.0;
        }
    }];
    
    
}

@end
