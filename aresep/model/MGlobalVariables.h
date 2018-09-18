//
//  MGlobalVariables.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGlobalVariables : NSObject

@property BOOL errorMessageShown;

+ (MGlobalVariables *)getInstance;

+ (void)destroyInstance;

@end
