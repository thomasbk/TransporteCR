//
//  ISerializable.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 20/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol ISerializable<NSObject>

@required
@property BOOL valid;

- (void)desSerialize:(NSDictionary *)jsonResult;
- (NSString *)serialize;



@end
