//
//  UIAlertView+Blocks.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RIButtonItem.h"

@interface UIAlertView (Blocks)

-(id)initWithTitle:(NSString *)inTitle message:(NSString *)inMessage cancelButtonItem:(RIButtonItem *)inCancelButtonItem otherButtonItems:(RIButtonItem *)inOtherButtonItems, ... NS_REQUIRES_NIL_TERMINATION;

- (NSInteger)addButtonItem:(RIButtonItem *)item;

@end
