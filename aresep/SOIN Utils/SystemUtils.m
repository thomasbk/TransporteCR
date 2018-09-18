//
//  SystemUtils.m
//  PESSO
//
//  Created by Alex on 3/30/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SystemUtils.h"

@implementation SystemUtils

+ (NSString *)getPathForFile:(NSString *)file
{
    NSString *applicationDocumentsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    NSString *result = [applicationDocumentsDir stringByAppendingPathComponent:file];
    
    return result;
}


@end
