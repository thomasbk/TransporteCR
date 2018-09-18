//
//  NameUtils.m
//  TicoExpress
//
//  Created by Christopher Jimenez on 4/8/13.
//
//

#import "NameUtils.h"

@implementation NameUtils

+ (NSString *) applicationName;
{
    
   NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    
    return appName;
}

+ (NSString *) applicationVersion;
{
    
    NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];

    return appVersion;
}

+ (NSString *) applicationBuild;
{
    
    NSString *appBuild = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    
    return appBuild;
}


@end


