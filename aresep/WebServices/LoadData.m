//
//  LoadData.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "LoadData.h"
#import "Constants.h"
#import "App_Data.h"
#import "Bus_Routes.h"
#import "Train_Routes.h"
#import "EventMacros.h"
#import "TypeUtil.h"
#define HOST                        SERVER_HOST
#define HOSTNEW                        SERVER_HOST_NEW
//#define APP_DATA_SERVICE_PATH       @"/cfmx/ICEPAD/public-ws/aresep/AppData.html"//@"/cfmx/Johnny/Componentes/public/ws.cfc"
//#define ROUTES_DATA_SERVICE_PATH    @"/cfmx/home/public/rutas.html"//@"/cfmx/Johnny/Componentes/public/ws.cfc"

#define APP_DATA_SERVICE_PATH       @"/rutas/appdata.html"
#define ROUTES_DATA_SERVICE_PATH    @"/Rutas/Rutas.html"
#define ROUTES_DATA_SERVICE_PATH_NEW    @"/Ruta/ObtenerRutas"
#define PORT                        SERVER_PORT
#define METHOD_GET_APP_DATA         @"getAppData"
#define METHOD_GET_ROUTES_DATA      @"getRoutesData"



@implementation LoadData

@synthesize valid = _valid;

- (id) initWithManajeContext:(NSManagedObjectContext*) aManagedObjectContext
  andPersistentStoreCoordinator:(NSPersistentStoreCoordinator*) aPersistentCoordinator
{
    self = [super init];
    
    if (self)
    {
        self.managedObjectContext  = aManagedObjectContext;
        self.persistentStoreCoordinator = aPersistentCoordinator;
    }
    
    return self;
}

- (void)setupWS
{
    if (self.soinWS == nil)
    {
        _soinWS                 = [[SoinWS alloc] init];
        self.soinWS.delegate    = self;
        self.soinWS.isHttps     = isHTTPS;
        self.soinWS.host        = HOST;
       // self.soinWS.port        = PORT;
        
    }
    self.soinWS.host        = HOST;
}

- (void)setupWSNew
{
    if (self.soinWS == nil)
    {
        _soinWS                 = [[SoinWS alloc] init];
        self.soinWS.delegate    = self;
        self.soinWS.isHttps     = isHTTPS;
        self.soinWS.host        = HOSTNEW;
        // self.soinWS.port        = PORT;
        
    }
    isHTTPS = YES;
    self.soinWS.host        = HOSTNEW;
}



- (void) loadAppDataFromServer
{
    
    [self setupWS];
    self.soinWS.servicePath = APP_DATA_SERVICE_PATH;
    self.soinWS.methodName = METHOD_GET_APP_DATA;
    
    [self.soinWS callSilent];
    
}

- (void) loadRouteDataFromServer
{
    //[self setupWS];
    [self setupWSNew];
    //self.soinWS.servicePath = ROUTES_DATA_SERVICE_PATH;
    self.soinWS.servicePath = ROUTES_DATA_SERVICE_PATH_NEW;
    self.soinWS.methodName = METHOD_GET_ROUTES_DATA;
    [self.soinWS callWithIndicatorMessage:@"Cargando Información de rutas"];
}

- (void) deleteData
{
    NSLog(@"Delete all Data");
    
    // delete data from tables instead of deleting DB TBK
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"App_Data"];
    NSBatchDeleteRequest *delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    
    NSError *deleteError = nil;
    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Bus_Routes"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    deleteError = nil;
    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    
    request = [[NSFetchRequest alloc] initWithEntityName:@"Train_Routes"];
    delete = [[NSBatchDeleteRequest alloc] initWithFetchRequest:request];
    deleteError = nil;
    [self.persistentStoreCoordinator executeRequest:delete withContext:self.managedObjectContext error:&deleteError];
    
    
    /*
    //Erase the persistent store from coordinator and also file manager.
    NSPersistentStore *store = [self.persistentStoreCoordinator.persistentStores lastObject];
    NSError *error = nil;
    NSURL *storeURL = store.URL;
    [self.persistentStoreCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error];
    
    NSLog(@"Data Reset");
    
    //Make new persistent store for future saves   (Taken From Above Answer)
    if (![self.persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // do something with the error
    }
     */
}

- (void)desSerialize:(NSDictionary *)jsonResult
{
    
    if ([self.soinWS.methodName isEqualToString:METHOD_GET_APP_DATA])
    {
        [self desSerializeAppData:jsonResult];
    }
    else if ( [self.soinWS.methodName isEqualToString: METHOD_GET_ROUTES_DATA])
    {
        [self desSerializeRoutes:jsonResult];
    }
    
}

- (void)desSerializeAppData:(NSDictionary *)jsonResult
{
    NSDictionary* jsonDict = [jsonResult objectForKey:@"app_data"];
    
    NSNumber *appVersion = [TypeUtil toNumber:[jsonDict objectForKey:@"version"]];
    
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"App_Data" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    
    if (array == nil)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:APP_DATA_DONE_RELOAD_ALL_EVENT object:self];
    }
    else
    {
        if ([array count] > 0)
        {
            App_Data *app = [array objectAtIndex:0];
            
            if ([appVersion doubleValue] > [app.version doubleValue])
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:APP_DATA_DONE_RELOAD_ALL_EVENT object:self];
            }
            else
            {
                [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
                [[NSNotificationCenter defaultCenter]postNotificationName:APP_DATA_DONE_EVENT object:self];
            }
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:APP_DATA_DONE_RELOAD_ALL_EVENT object:self];
        }
        
        
    }
    
}

- (void)desSerializeRoutes:(NSDictionary *)jsonResult
{
    
    NSDictionary* jsonDict = [jsonResult objectForKey:@"app_data"];
    
    App_Data* AppData = [NSEntityDescription insertNewObjectForEntityForName:@"App_Data" inManagedObjectContext:self.managedObjectContext];
    
    AppData.created_date = [TypeUtil toDate:[jsonDict objectForKey:@"created_date"]];
    AppData.modified_date = [TypeUtil toDate:[jsonDict objectForKey:@"modified_date"]];
    AppData.version = [TypeUtil toNumber:[jsonDict objectForKey:@"version"]];
    
    
    /*-- Carga de Datos sobre la ruta de Buses --*/
    NSArray* busRoutesJSON = [jsonResult objectForKey:@"Bus_Routes"];
    if ([busRoutesJSON lastObject])
    {
        for (NSDictionary *jsonDict in busRoutesJSON)
        {
            
            if ([jsonDict count] > 0)
            {
                Bus_Routes* data = [NSEntityDescription insertNewObjectForEntityForName:@"Bus_Routes" inManagedObjectContext:self.managedObjectContext];
                
                
                NSDictionary *attributes = [[data entity] attributesByName];
                for (NSString *attribute in attributes) {
                    id value = [jsonDict objectForKey:attribute];
                    if (value == nil ) {
                        //|| [value isEqualToString:@"NULL"]
                        continue;
                    }
                    [data setValue:value forKey:attribute];
                }
            }
        }
    }
    
    /*-- Carga de Datos sobre la ruta de Buses --*/
    NSArray* trainRoutesJSON = [jsonResult objectForKey:@"Train_Routes"];
    if ([trainRoutesJSON lastObject])
    {
        for (NSDictionary *jsonDict in trainRoutesJSON)
        {
            
            if ([jsonDict count] > 0)
            {
                Train_Routes* data = [NSEntityDescription insertNewObjectForEntityForName:@"Train_Routes" inManagedObjectContext:self.managedObjectContext];
                
                
                NSDictionary *attributes = [[data entity] attributesByName];
                for (NSString *attribute in attributes) {
                    id value = [jsonDict objectForKey:attribute];
                    if (value == nil ) {
                        //|| [value isEqualToString:@"NULL"]
                        continue;
                    }
                    [data setValue:value forKey:attribute];
                }
            }
        }
    }
    
    
    [[NSNotificationCenter defaultCenter]postNotificationName:HIDE_PROGRESS_INDICATOR object:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:ROUTES_DATA_DONE_EVENT object:self];
}

- (NSString*)serialize
{
    return @"";
}

- (void)answerReceived:(NSDictionary *)result
{
    [self desSerialize:result];
}

- (void) connectionFailed:(NSString *)errorDescription
{
    // Notify the observers about the connection problem
    [[NSNotificationCenter defaultCenter]postNotificationName:CONNECTION_ERROR_EVENT object:nil];
}



@end
