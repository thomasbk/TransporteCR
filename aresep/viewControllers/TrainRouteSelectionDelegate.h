//
//  TrainRouteSelectionDelegate.h
//  aresep
//
//  Created by Christopher Jimenez on 10/30/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Train_Routes.h"

@protocol TrainRouteSelectionDelegate <NSObject>

- (void) trainRouteSelected:(Train_Routes *)aTrainRoute;

@end

