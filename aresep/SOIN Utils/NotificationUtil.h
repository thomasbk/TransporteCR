//
//  NotificationUtil.h
//  PESSO
//
//  Created by Christopher Jimenez on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationUtil : NSObject


+(void)connectNotification:(SEL)selectorObject toObject:(NSObject*)object withNotificationName:(NSString *)notificatioName;

+(void)disconectNotification:(NSObject*)object withNotificationName:(NSString *)notificatioName;

+(void)connectNotificationConnectionError:(SEL)selectorObject toObject:(NSObject*)object;

+(void)disconectNotificationConnectionError:(NSObject*)object;

@end
