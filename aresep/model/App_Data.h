//
//  App_Data.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface App_Data : NSManagedObject

@property (nonatomic, retain) NSDate * created_date;
@property (nonatomic, retain) NSDate * modified_date;
@property (nonatomic, retain) NSNumber * version;

@end
