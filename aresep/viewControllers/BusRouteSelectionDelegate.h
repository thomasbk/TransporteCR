//
//  BusRouteSelectionDelegate.h
//  aresep
//
//  Created by Christopher Jimenez on 10/30/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Bus_Routes.h"

@protocol BusRouteSelectionDelegate <NSObject>

- (void) busRouteSelected:(Bus_Routes *)aBusRoute;

@end

