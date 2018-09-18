//
//  BusRouteOptionSelectionViewController.h
//  aresep
//
//  Created by Christopher Jimenez on 10/30/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AresepViewController.h"
#import "Bus_Routes.h"
#import "ZBarSDK.h"
#import "BusRouteSelectionDelegate.h"

@interface BusRouteOptionSelectionViewController : AresepViewController<ZBarReaderDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;

/*- Labels -*/
@property (weak, nonatomic) IBOutlet UILabel *contentTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *listLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *listLabel;

@property (weak, nonatomic) IBOutlet UILabel *scanLabelTitle;
@property (weak, nonatomic) IBOutlet UILabel *scanLabel;

@property (nonatomic, weak)id <BusRouteSelectionDelegate> delegate;


@end
