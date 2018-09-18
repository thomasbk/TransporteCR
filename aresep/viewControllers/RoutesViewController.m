//
//  RoutesViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 23/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "RoutesViewController.h"
#import "IOSVersion.h"
#import "RouteDetailsViewController.h"
#import "TrainRouteSelectionViewController.h"
#import "aresep-Swift.h"
#import "InformationViewController.h"
#import "AppDelegate.h"
#import "AlertUtil.h"
#import "Fonts.h"
#import "LoadData.h"
#import "BusRouteOptionSelectionViewController.h"



@interface RoutesViewController ()

- (IBAction)trainSelected:(id)sender;
- (IBAction)busSelected:(id)sender;
- (void) setFont;
- (IBAction)showInfo:(id)sender;
- (void) loadAppDataRespose;
- (void) loadAppDataReloadAllRespose;
- (void) loadRoutesDateResponse;
- (void) busRouteSelected:(Bus_Routes *)aBusRoute;
- (void) trainRouteSelected:(Train_Routes *)aTrainRoute;

//@property (nonatomic, strong) TestViewController *taxiVC;

@end

@implementation RoutesViewController

#define BUS_SELECTED 0
#define TRAIN_SELECTED 1

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        
        // Custom initialization
    }
    return self;
}


- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
                 andData:(LoadData*)aData
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        self.data = aData;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"Inicio"];
    [self setRadiusStyle:self.contentView];
    
    [NotificationUtil connectNotification:@selector(loadRoutesDateResponse) toObject:self withNotificationName:ROUTES_DATA_DONE_EVENT];
    
    [NotificationUtil connectNotification:@selector(loadAppDataReloadAllRespose) toObject:self withNotificationName:APP_DATA_DONE_RELOAD_ALL_EVENT];
    
    [NotificationUtil connectNotification:@selector(loadAppDataRespose) toObject:self withNotificationName:APP_DATA_DONE_EVENT];
    
    [self.data loadAppDataFromServer];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self setStyledBackButton];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    [self setFont];
}

// Add this Method
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super  viewDidDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void) loadAppDataRespose
{
    //[self.data loadRouteDataFromServer];
}

- (void) loadAppDataReloadAllRespose
{
    [self.data deleteData];
    [self.data loadRouteDataFromServer];
}

- (void) loadRoutesDateResponse
{
    
}

//- (IBAction)scanCode:(id)sender {
//    
//    // ADD: present a barcode reader that scans from the camera feed
//    ZBarReaderViewController *reader = [ZBarReaderViewController new];
//    reader.readerDelegate = self;
//    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
//    
//    ZBarImageScanner *scanner = reader.scanner;
//    // TODO: (optional) additional reader configuration here
//    
//    // EXAMPLE: disable rarely used I2/5 to improve performance
//    [scanner setSymbology: ZBAR_I25
//                   config: ZBAR_CFG_ENABLE
//                       to: 0];
//    
//    // present and release the controller
//    [self presentViewController: reader
//                       animated: YES completion:NULL];
//
//}

//- (void) imagePickerController: (UIImagePickerController*) reader
// didFinishPickingMediaWithInfo: (NSDictionary*) info
//{
//    
//
//    // ADD: get the decode results
//    id<NSFastEnumeration> results =
//    [info objectForKey: ZBarReaderControllerResults];
//    ZBarSymbol *symbol = nil;
//    for(symbol in results)
//        // EXAMPLE: just grab the first barcode
//        break;
//    
//    
//    // EXAMPLE: do something useful with the barcode data
//    
//    if(self.isBusRouteSelected)
//    {
//        int busId = [symbol.data intValue];
//        Bus_Routes * busRoute = [self getBusRouteByID:busId];
//        if(busRoute)
//        {
//            [self busRouteSelected:busRoute];
//            
//        }
//       
//    }
////    else
////    {
////        
////    }
//    
//    
//    // EXAMPLE: do something useful with the barcode image
//    // resultImage.image =
//    //[info objectForKey: UIImagePickerControllerOriginalImage];
//    
//    // ADD: dismiss the controller (NB dismiss from the *reader*!)
//    
//    [reader dismissViewControllerAnimated:YES completion:^{
//        [self showRouteInformation];
//            }];
//
//}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showRouteInformation:(id)sender
{
    [self showRouteInformation];
}

- (void) busRouteSelected:(Bus_Routes *)aBusRoute;
{
    RouteDetailsViewController * view = [[RouteDetailsViewController alloc]initWithNibName:@"RouteDetailsViewController" bundle:nil withBusRoute:aBusRoute];
    
    [self.navigationController pushViewController:view animated:YES];
}

- (void) trainRouteSelected:(Train_Routes *)aTrainRoute
{
    RouteDetailsViewController * view = [[RouteDetailsViewController alloc] initWithNibName:@"RouteDetailsViewController" bundle:nil withTrainRoute:aTrainRoute];
    
    [self.navigationController pushViewController:view animated:YES];
}

-(void)showRouteInformation
{
    
//    if (self.isBusRouteSelected)
//    {
//        if (self.busRouteSelected)
//        {
//            self.trainRouteSelected = nil;
//            
//            RouteDetailsViewController * view = [[RouteDetailsViewController alloc]initWithNibName:@"RouteDetailsViewController" bundle:nil withBusRoute:self.busRouteSelected];
//            
//            [self.navigationController pushViewController:view animated:YES];
//        }
//        else
//        {
//            [AlertUtil showErrorMessageInView:self.view withMessage:@"Seleccione una ruta de Bus" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
//        }
//    }
//    else
//    {
//        if (self.trainRouteSelected)
//        {
//            self.busRouteSelected = nil;
//            
//            RouteDetailsViewController * view = [[RouteDetailsViewController alloc] initWithNibName:@"RouteDetailsViewController" bundle:nil withTrainRoute:self.trainRouteSelected];
//            
//            [self.navigationController pushViewController:view animated:YES];
//        }
//        else
//        {
//            [AlertUtil showErrorMessageInView:self.view withMessage:@"Seleccione una ruta de Tren" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
//        }
//    }
}



- (IBAction)trainSelected:(id)sender {
    
    TrainRouteSelectionViewController *view = [[TrainRouteSelectionViewController alloc] initWithNibName:@"TrainRouteSelectionViewController" bundle:nil];
    
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    view.managedObjectContext = appDelegate.managedObjectContext;
    view.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self.navigationController  presentViewController:nav animated:YES completion:nil];
}

- (IBAction)busSelected:(id)sender {
    
    BusRouteOptionSelectionViewController *view = [[BusRouteOptionSelectionViewController alloc] initWithNibName:@"BusRouteOptionSelectionViewController" bundle:nil];
    
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    view.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self  presentViewController:nav animated:YES completion:nil];
    
}

- (IBAction)taxiSelected:(id)sender {
    
    //TaxiMapViewController *view = [[TaxiMapViewController alloc] initWithNibName:@"TaxiMapViewController" bundle:nil];
    
    //TaxiMapViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TaxiMapViewController"];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TaxiMapViewController *taxiVC = [mainStoryboard instantiateViewControllerWithIdentifier:@"TaxiMapViewController"];
    //[self.navigationController pushViewController:taxiVC animated:YES];
    
    //self.storyboard?.instantiateViewControllerWithIdentifier("TaxiMapViewController") as SwfViewController

    
    //viewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    //viewController.delegate = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:taxiVC];
    
    [nav setNavigationBarHidden:YES animated:YES];
    
    [self  presentViewController:nav animated:YES completion:nil];
    
}

- (void)setFont
{
    [self.contentTitleLabel setFont:[Fonts boldFontWithSize:14.0f]];
    [self.infoButton.titleLabel setFont:[Fonts regularFontWithSize:15.0f]];
    
}

- (IBAction)showInfo:(id)sender
{
    InformationViewController *view = [[InformationViewController alloc] initWithNibName:@"InformationViewController" bundle:nil];
    
    view.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];
    
    [self  presentViewController:nav animated:YES completion:nil];
    
}


@end
