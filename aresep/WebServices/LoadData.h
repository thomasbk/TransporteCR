//
//  LoadData.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SoinWS.h"
#import "ISerializable.h"
#import <CoreData/CoreData.h>

#define APP_DATA_DONE_EVENT               @"AppDataDoneEvent"
#define APP_DATA_DONE_RELOAD_ALL_EVENT    @"AppDataDoneReloadAllEvent"
#define ROUTES_DATA_DONE_EVENT            @"RoutesDataDoneEvent"

@interface LoadData : NSObject <ISerializable, SoinWSDelegate, NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSManagedObjectContext *          managedObjectContext;
@property (nonatomic, strong) NSPersistentStoreCoordinator  *   persistentStoreCoordinator;

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@property (strong, nonatomic) SoinWS *soinWS;

- (id) initWithManajeContext:(NSManagedObjectContext*) aManagedObjectContext
 andPersistentStoreCoordinator:(NSPersistentStoreCoordinator*) aPersistentCoordinator;

- (void) loadAppDataFromServer;

- (void) loadRouteDataFromServer;

- (void) setupWS;

- (void) deleteData;


@end
