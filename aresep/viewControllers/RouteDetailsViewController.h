//
//  RouteDetailsViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 24/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"
#import "MessageUI/MessageUI.h"
#import "Bus_Routes.h"
#import "Train_Routes.h"

@interface RouteDetailsViewController : AresepViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *regularFareView;
@property (weak, nonatomic) IBOutlet UIView *seniorFareView;

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *operatorNameLabel;


@property (weak, nonatomic) IBOutlet UILabel *regularFareLabel;
@property (weak, nonatomic) IBOutlet UILabel *seniorFareLabel;


@property (nonatomic, strong) Bus_Routes* busRoute;
@property (nonatomic, strong) Train_Routes* trainRoute;

/*- Labels -*/
@property (weak, nonatomic) IBOutlet UILabel *operatorTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *officialFareTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *regularFareTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *seniorFareTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *operationsTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *reportIncidentButton;
@property (weak, nonatomic) IBOutlet UIButton *operatorPhoneButton;
@property (weak, nonatomic) IBOutlet UIButton *operatorEmailButton;

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
          withBusRoute:(Bus_Routes*)aBusRoute;

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
        withTrainRoute:(Train_Routes*)aTrainRoute;

@end
