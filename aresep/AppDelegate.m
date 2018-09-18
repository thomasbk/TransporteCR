//
//  AppDelegate.m
//  aresep
//
//  Created by Christopher Jimenez on 8/12/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AppDelegate.h"
#import "ContactUsViewController.h"
#import "UIImage+iPhone5.h"
#import "Bus_Routes.h"
#import "Train_Routes.h"
#import "App_Data.h"
#import "RoutesViewController.h"
#import "LoadData.h"
#import <CoreData/CoreData.h>
@import GoogleMaps;
@import GooglePlaces;

#import "aresep-Swift.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{

    //[GMSServices provideAPIKey:@"AIzaSyD_76TBS1hTEqfbm7jmH6i9DNEn73OXDvo"];
    //[GMSPlacesClient provideAPIKey:@"AIzaSyD_76TBS1hTEqfbm7jmH6i9DNEn73OXDvo"];
    
    [GMSServices provideAPIKey:@"AIzaSyDs5lBK6jGTYCE4Od6-AeW7Syp7BqXb3q0"];
    [GMSPlacesClient provideAPIKey:@"AIzaSyDs5lBK6jGTYCE4Od6-AeW7Syp7BqXb3q0"];
    
    
    NSManagedObjectContext* context = [self managedObjectContext];
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    
    _data = [[LoadData alloc] initWithManajeContext:context andPersistentStoreCoordinator:coordinator];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    RoutesViewController *view = [[RoutesViewController alloc] initWithNibName:@"RoutesViewController" bundle:nil andData:self.data];
 
    _navigationController = [[UINavigationController alloc] initWithRootViewController:view];

    
    self.window.rootViewController = self.navigationController;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}


-(void) applicationWillEnterForeground:(UIApplication *)application
{
    [self.data loadAppDataFromServer];
}

    - (void)applicationWillTerminate:(UIApplication *)application
    {
        [self saveContext];
    }
    
    
    - (void)applicationWillResignActive:(UIApplication *)application
    {
        [self saveContext];
    }
    
    
    - (void)applicationDidEnterBackground:(UIApplication *)application
    {
        [self saveContext];
    }


# pragma mark - Rotation

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navController = (UINavigationController*) self.window.rootViewController;
        if ([navController.visibleViewController isKindOfClass:[TaxiMapViewController class]]
            || [navController.visibleViewController isKindOfClass:[UIAlertController class]]) {
        
        // Get topmost/visible view controller
        //UIViewController *currentViewController = [self.window.rootViewController.childViewControllers lastObject];
            
        // Check whether it implements a dummy methods called canRotate
        if ([navController.visibleViewController respondsToSelector:@selector(canRotate)]) {
            // Unlock landscape view orientations for this view controller
            return UIInterfaceOrientationMaskAllButUpsideDown;
        }
    }
    }
    
    // Only allow portrait (standard behaviour)
    return UIInterfaceOrientationMaskPortrait;
}
-(void)canRotate
{
}
    
    
    - (void)saveContext
    {
        NSError *error;
        if (_managedObjectContext != nil) {
            if ([_managedObjectContext hasChanges] && ![_managedObjectContext save:&error]) {
                /*
                 Replace this implementation with code to handle the error appropriately.
                 
                 abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 */
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                abort();
            }
        }
    }

    
    
#pragma mark - Core Data stack
    
    /*
     Returns the managed object context for the application.
     If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
     */
    - (NSManagedObjectContext *) managedObjectContext
    {
        if (_managedObjectContext != nil) {
            return _managedObjectContext;
        }
        
        NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
        if (coordinator != nil) {
            _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
            [_managedObjectContext setPersistentStoreCoordinator: coordinator];
        }
        return _managedObjectContext;
    }
    
    
    // Returns the managed object model for the application.
    // If the model doesn't already exist, it is created from the application's model.
    - (NSManagedObjectModel *)managedObjectModel
    {
        if (_managedObjectModel != nil) {
            return _managedObjectModel;
        }
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"aresep" withExtension:@"momd"];
        _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return _managedObjectModel;
    }
    
    
    /*
     Returns the persistent store coordinator for the application.
     If the coordinator doesn't already exist, it is created and the application's store added to it.
     */
    - (NSPersistentStoreCoordinator *)persistentStoreCoordinator
    {
        if (_persistentStoreCoordinator != nil) {
            return _persistentStoreCoordinator;
        }
        
        NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"aresep.sqlite"];
        
        /*
         Set up the store.
         For the sake of illustration, provide a pre-populated default store.
         */
        NSFileManager *fileManager = [NSFileManager defaultManager];
        // If the expected store doesn't exist, copy the default store.
        if (![fileManager fileExistsAtPath:[storeURL path]]) {
            NSURL *defaultStoreURL = [[NSBundle mainBundle] URLForResource:@"aresep" withExtension:@"sqlite"];
            if (defaultStoreURL) {
                [fileManager copyItemAtURL:defaultStoreURL toURL:storeURL error:NULL];
            }
        }
        
        NSDictionary *options = @{NSMigratePersistentStoresAutomaticallyOption: @YES, NSInferMappingModelAutomaticallyOption: @YES};
        _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel: [self managedObjectModel]];
        
        NSError *error;
        if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
             
             Typical reasons for an error here include:
             * The persistent store is not accessible;
             * The schema for the persistent store is incompatible with current managed object model.
             Check the error message to determine what the actual problem was.
             
             
             If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
             
             If you encounter schema incompatibility errors during development, you can reduce their frequency by:
             * Simply deleting the existing store:
             [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
             
             * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
             @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
             
             Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
             
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        return _persistentStoreCoordinator;
    }

#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    // The persistent container for the application. This implementation creates and returns a container, having loaded the store for the application to it.
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"aresep"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    // Replace this implementation with code to handle the error appropriately.
                    // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                    
                    /*
                     Typical reasons for an error here include:
                     * The parent directory does not exist, cannot be created, or disallows writing.
                     * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                     * The device is out of space.
                     * The store could not be migrated to the current model version.
                     Check the error message to determine what the actual problem was.
                     */
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }
    
    return _persistentContainer;
}


- (void)saveContextCD {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}
    
    
#pragma mark - Application's documents directory
    
    // Returns the URL to the application's Documents directory.
    - (NSURL *)applicationDocumentsDirectory
    {
        return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    }

@end
