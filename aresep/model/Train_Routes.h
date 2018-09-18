//
//  Train_Routes.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Train_Routes : NSManagedObject

@property (nonatomic, retain) NSString * emailComplaint;
@property (nonatomic, retain) NSString * operator;
@property (nonatomic, retain) NSString * operatorTel;
@property (nonatomic, retain) NSString * parentRouteName;
@property (nonatomic, retain) NSString * regularFare;
@property (nonatomic, retain) NSString * routeName;
@property (nonatomic, retain) NSString * seniorFare;
@property (nonatomic, retain) NSNumber * routeId;

@end
