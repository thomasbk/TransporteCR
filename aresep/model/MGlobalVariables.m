//
//  MGlobalVariables.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "MGlobalVariables.h"

static MGlobalVariables *_instance;

@implementation MGlobalVariables
@synthesize errorMessageShown = _errorMessageShown;


#pragma mark - Class methods


- (id)init
{
    self = [super init];
    
    if (self)
    {
        self.errorMessageShown = NO;
    }
    
    return self;
}

//Class methods
+ (MGlobalVariables *)getInstance
{
    
    if (!_instance)
    {
        _instance = [[MGlobalVariables alloc] init];
        
    }
    
    return _instance;
}

+ (void)destroyInstance
{
    if (_instance)
    {
        _instance = nil;
    }
}


@end
