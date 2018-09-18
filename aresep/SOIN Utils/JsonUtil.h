//
//  JsonUtil.h
//  icepad
//
//  Created by Christopher Jimenez on 5/14/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JsonUtil : NSObject

+(void)checkResponseError:(NSDictionary *)json successEvent:(NSString *)event;

@end
