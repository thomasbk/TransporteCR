//
//  BusRouteOptionSelectionViewController.m
//  aresep
//
//  Created by Christopher Jimenez on 10/30/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "BusRouteOptionSelectionViewController.h"
#import "AppDelegate.h"
#import "RouteDetailsViewController.h"
#import "BusRouteSelectionViewController.h"
#import "CJZBarReaderViewController.h"
#import "AlertUtil.h"
#import "Fonts.h"

@interface BusRouteOptionSelectionViewController ()

-(void)scanCode;

@end

@implementation BusRouteOptionSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (IBAction)listSelected:(id)sender {
    
    BusRouteSelectionViewController *view = [[BusRouteSelectionViewController alloc] initWithNibName:@"BusRouteSelectionViewController" bundle:nil];
    
    view.delegate = self.delegate;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    view.managedObjectContext = appDelegate.managedObjectContext;
    
    [self.navigationController  pushViewController:view animated:YES];
    
}

- (IBAction)scanSelected:(id)sender
{
    [self scanCode];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setRadiusStyle:self.contentView];
    
    [self addNavigationButtonLeft:@"Cerrar" target:self action:@selector(closeModal)];

    // Do any additional setup after loading the view from its nib.
}

- (void) closeModal
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setStyledBackButton];
    
    
    //[self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setFont];
    
}


-(void)scanCode {
    
    // ADD: present a barcode reader that scans from the camera feed
    CJZBarReaderViewController *reader = [CJZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    
    ZBarImageScanner *scanner = reader.scanner;
    // TODO: (optional) additional reader configuration here
    
    // EXAMPLE: disable rarely used I2/5 to improve performance
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    // present and release the controller
    [self presentViewController: reader
                       animated: YES completion:NULL];
    
}

- (void) imagePickerController: (UIImagePickerController*) reader
 didFinishPickingMediaWithInfo: (NSDictionary*) info
{
    
    
    // ADD: get the decode results
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        // EXAMPLE: just grab the first barcode
        break;
    

    int busId = [symbol.data intValue];
    Bus_Routes * busRoute = [self getBusRouteByID:busId];
    
    if(busRoute)
    {
        [reader dismissViewControllerAnimated:YES completion:^{
        
       
                [self.navigationController dismissViewControllerAnimated:YES completion:^
                 {
                     [self.delegate busRouteSelected:busRoute];
                 }];
        
        }];
    }
    else
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"El código escaneado no corresponde a ninguna ruta."andTitle:@"Mi Ruta"];
    }
    
}

- (Bus_Routes *) getBusRouteByID:(int)idRoute
{
    Bus_Routes * route =  nil;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSManagedObjectContext *moc = appDelegate.managedObjectContext;;
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"Bus_Routes" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"routeId == %d", idRoute];
    [request setPredicate:predicate];
    
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array != nil && array.count > 0)
    {
        route =  [array objectAtIndex:0];
        // Deal with error...
    }
    
    return route;
}



- (void)setFont
{
    [self.contentTitleLabel setFont:[Fonts boldFontWithSize:14.0f]];
    
    [self.listLabelTitle setFont:[Fonts boldFontWithSize:14.0f]];
    [self.listLabel setFont:[Fonts regularFontWithSize:14.0f]];
    
    [self.scanLabelTitle setFont:[Fonts boldFontWithSize:14.0f]];
    [self.scanLabel setFont:[Fonts regularFontWithSize:14.0f]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
