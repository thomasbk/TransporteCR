//
//  JsonUtil.m
//  icepad
//
//  Created by Christopher Jimenez on 5/14/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "JsonUtil.h"
#import "TypeUtil.h"
#import "NotificationUtil.h"
#import "Constants.h"
#import "EventMacros.h"

@implementation JsonUtil

+(void)checkResponseError:(NSDictionary *)json successEvent:(NSString *)event
{
    
    id jsonResponse = [json objectForKey:@"response"];
    
    BOOL success = [TypeUtil toBOOLFromHTMLCode:[jsonResponse objectForKey:@"success"]];
    if(success)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:event object:self];
    }
    else
    {
        NSString * errorString = [TypeUtil toString:[jsonResponse objectForKey:@"desc"]];
        
        NSLog(@"Error executing service %@",errorString);
        
        NSDictionary *messageDict = [NSDictionary dictionaryWithObjectsAndKeys:errorString,@"message",nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:SHOW_MESSAGE_EVENT object:nil userInfo:messageDict];
        
    }
    
}

@end



