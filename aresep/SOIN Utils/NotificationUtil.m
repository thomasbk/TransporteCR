//
//  NotificationUtil.m
//  PESSO
//
//  Created by Christopher Jimenez on 3/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NotificationUtil.h"
#import "EventMacros.h"

@implementation NotificationUtil

+(void)connectNotification:(SEL)selectorObject toObject:(NSObject*)object withNotificationName:(NSString *)notificatioName
{
    [[NSNotificationCenter defaultCenter]
     addObserver:object
     selector:selectorObject
     name:notificatioName    
     object:nil ];
}

+(void)disconectNotification:(NSObject*)object withNotificationName:(NSString *)notificatioName
{
    [[NSNotificationCenter defaultCenter]
     removeObserver:object name:notificatioName object:nil];
}


+(void)connectNotificationConnectionError:(SEL)selectorObject toObject:(NSObject*)object
{
    [[NSNotificationCenter defaultCenter]
     addObserver:object
     selector:selectorObject
     name:CONNECTION_ERROR_EVENT    
     object:nil ];
}


+(void)disconectNotificationConnectionError:(NSObject*)object
{
    
    [[NSNotificationCenter defaultCenter]
     removeObserver:object name:CONNECTION_ERROR_EVENT object:nil];
}

@end
