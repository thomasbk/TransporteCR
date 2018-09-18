//
//  AppDelegate.h
//  aresep
//
//  Created by Christopher Jimenez on 8/12/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ColorSwitcher.h"
#import "LoadData.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (readonly, strong, nonatomic) NSPersistentContainer *persistentContainer;


@property (strong, nonatomic) UINavigationController* navigationController;
@property (strong, nonatomic) LoadData* data;

- (void)saveContext;
- (void)saveContextCD;

- (NSURL *)applicationDocumentsDirectory;


@end
