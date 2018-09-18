//
//  UITableView+Utils.m
//  TicoExpress
//
//  Created by Christopher Jimenez on 9/14/12.
//
//

#import "UITableView+Utils.h"
#import <QuartzCore/QuartzCore.h>

@implementation UITableView (Utils)


- (void)reloadDataAnimated:(BOOL)animated
{
    [self reloadData];
    
    if (animated) {
        
        CATransition *animation = [CATransition animation];
        [animation setType:kCATransitionPush];
        [animation setSubtype:kCATransitionFromBottom];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setFillMode:kCAFillModeBoth];
        [animation setDuration:.3];
        [[self layer] addAnimation:animation forKey:@"UITableViewReloadDataAnimationKey"];
        
    }
}

@end
