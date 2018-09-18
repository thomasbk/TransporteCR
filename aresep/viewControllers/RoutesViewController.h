//
//  RoutesViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 23/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//  Esta clase muestra las rutas de los buses
//

#import "AresepViewController.h"
#import "BusRouteSelectionDelegate.h"
#import "TrainRouteSelectionDelegate.h"
#import "Bus_Routes.h"
#import "Train_Routes.h"
#import "LoadData.h"
#import "ZBarSDK.h"

@interface RoutesViewController : AresepViewController<BusRouteSelectionDelegate, TrainRouteSelectionDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

@property (weak, nonatomic) IBOutlet UIButton *busRouteButtonSelection;
@property (weak, nonatomic) IBOutlet UIButton *trainRouteButtonSelection;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;

@property (strong, nonatomic) LoadData* data;

/*- Labels -*/
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;


@property (nonatomic, strong) NSPersistentStoreCoordinator  *   persistentStoreCoordinator;

- (id)initWithNibName:(NSString *)nibNameOrNil
               bundle:(NSBundle *)nibBundleOrNil
              andData:(LoadData*)aData;

@end
