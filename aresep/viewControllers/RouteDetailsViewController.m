//
//  RouteDetailsViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 24/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "RouteDetailsViewController.h"
#import "NSNumber+Utils.h"
#import "NSString+Utils.h"
#import "ContactUsViewController.h"
#import "Fonts.h"
#import "Colors.h"
#import "IOSVersion.h"
#import "MapViewController.h"

@interface RouteDetailsViewController ()

@property BOOL isBusRoute;

- (IBAction)callOperator:(id)sender;
- (IBAction)reportIncident:(id)sender;
- (IBAction)sendEmail:(id)sender;

- (void) setFonts;

@end

@implementation RouteDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.busRoute = nil;
        self.isBusRoute = NO;
        self.trainRoute = nil;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
          withBusRoute:(Bus_Routes*)aBusRoute
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.busRoute = aBusRoute;
        self.isBusRoute = YES;
        self.trainRoute = nil;
    }
    return self;
}

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
        withTrainRoute:(Train_Routes*)aTrainRoute
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.trainRoute = aTrainRoute;
        self.isBusRoute = NO;
        self.busRoute = nil;
    }
    return self;
}

-(void) showMap
{
    NSString * mapURL = @"";
    if(self.isBusRoute)
    {
        mapURL =  self.busRoute.mapImage;
    }
    
    //mapURL = @"http://costa-rica-guide.com/travel/images/stories/CostaRicaParkMap.png";
    
    MapViewController *mapViewController = [[MapViewController alloc] initWithNibName:@"MapViewController" bundle:nil mapURL:mapURL];
    
    mapViewController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:mapViewController];
    
    [self.navigationController  presentViewController:nav animated:YES completion:nil];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setTitle:@"TARIFAS"];
    
    [self setStyledBackButton];
    [self setRadiusStyle:self.viewHeader];
    [self setRadiusStyle:self.regularFareView];
    [self setRadiusStyle:self.seniorFareView];
    
    if(self.isBusRoute)
    {
        if(![self.busRoute.mapImage isEmpty] && self.busRoute.mapImage != nil)
        //if(![self.busRoute.mapImage isEmpty])
        {
            [self addNavigationButtonRight:@"Mapa" target:self action:@selector(showMap)];
        }
    }
    
    if (self.isBusRoute)
    {
        self.routeNameLabel.text = self.busRoute.routeName;
        self.operatorNameLabel.text = self.busRoute.operator;
        self.regularFareLabel.text = [self.busRoute.regularFare monetaryValue]; //[self.busRoute.regularFare monetaryValue];
        self.seniorFareLabel.text = [self.busRoute.seniorFare monetaryValue]; //[self.busRoute.seniorFare monetaryValue];
        [self.operatorEmailButton setTitle:self.busRoute.emailComplaint forState:UIControlStateNormal];
        if ([self.busRoute.emailComplaint isEmpty])
        {
            [self.operatorEmailButton setHidden:YES];
        }
        
        [self.operatorPhoneButton setTitle:self.busRoute.operatorTel forState:UIControlStateNormal];
        if ([self.busRoute.operatorTel isEmpty])
        {
            [self.operatorPhoneButton setHidden:YES];
        }
        
        if (([self.busRoute.operatorTel isEmpty] || self.busRoute.operatorTel ==nil ) && ([self.busRoute.emailComplaint isEmpty] || self.busRoute.emailComplaint == nil ))
        {
            [self.contactTitleLabel setHidden:YES];
            
            self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 80);
            
        }
    }
    else
    {
        self.routeNameLabel.text = self.trainRoute.routeName;
        self.operatorNameLabel.text = self.trainRoute.operator;
        self.regularFareLabel.text = [self.trainRoute.regularFare monetaryValue] ;
        self.seniorFareLabel.text = [self.trainRoute.seniorFare monetaryValue];
        [self.operatorEmailButton setTitle:self.trainRoute.emailComplaint forState:UIControlStateNormal];
        [self.operatorEmailButton setHidden:YES];
        [self.operatorPhoneButton setHidden:YES];
        [self.contactTitleLabel setHidden:YES];

        
        self.viewHeader.frame = CGRectMake(self.viewHeader.frame.origin.x, self.viewHeader.frame.origin.y, self.viewHeader.frame.size.width, 80);
        [self.operationsTitleLabel setHidden:YES];
        [self.reportIncidentButton setHidden:NO];
        
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)callOperator:(id)sender
{
    NSString* callNumber = @"";
    if (self.isBusRoute)
    {
        callNumber = self.busRoute.operatorTel;
    }
    else
    {
        callNumber = self.trainRoute.operatorTel;
    }
    
    NSString* callString = [NSString stringWithFormat:@"Tel:%@",callNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

- (IBAction)reportIncident:(id)sender
{
    ContactUsViewController* view;
    if (self.isBusRoute)
    {
        view = [[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil withBusRoute:self.busRoute];
    }
    else
    {
        view = [[ContactUsViewController alloc]initWithNibName:@"ContactUsViewController" bundle:nil withTrainRoute:self.trainRoute];
    }
    
    [self.navigationController  pushViewController:view animated:YES];
}

- (IBAction)sendEmail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
        NSString* mailto = self.isBusRoute ? self.busRoute.emailComplaint : self.trainRoute.emailComplaint;
        NSArray *toRecipients = [NSArray arrayWithObjects:mailto, nil];
        [mailer setToRecipients:toRecipients];

        if([IOSVersion isIOS7])
        {

            [mailer.navigationBar setBarTintColor:[Colors navigationBarColor]];
            [mailer.navigationBar setTranslucent:NO];
            mailer.navigationBar.barStyle = UIBarStyleBlackOpaque;

            
        }
        else
        {
            [mailer.navigationBar setTintColor:[Colors navigationBarColor]];
        }
        
        [self presentViewController:mailer animated:YES completion:nil];

    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Mi Ruta"
                                                        message:@"Debes tener alguna cuenta de correo configurada en tu dispositivo"
                                                       delegate:nil
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil];
        [alert show];
    }
}



- (void)setFonts
{
    [self.routeNameLabel setFont:[Fonts boldFontWithSize:18.0f]];
    [self.operationsTitleLabel setFont:[Fonts boldFontWithSize:12.0f]];
    [self.operatorNameLabel setFont:[Fonts regularFontWithSize:12.0f]];
    [self.contactTitleLabel setFont:[Fonts regularFontWithSize:12.0f]];
    
    [self.officialFareTitleLabel setFont:[Fonts boldFontWithSize:16.0f]];
    [self.regularFareTitleLabel setFont:[Fonts regularFontWithSize:16.0f]];
    [self.regularFareLabel setFont:[Fonts regularFontWithSize:22.0f]];
    [self.seniorFareTitleLabel setFont:[Fonts regularFontWithSize:16.0f]];
    [self.seniorFareLabel setFont:[Fonts regularFontWithSize:22.0f]];
    
    [self.operationsTitleLabel setFont:[Fonts boldFontWithSize:16.0f]];
    
    [self.reportIncidentButton.titleLabel setFont:[Fonts boldFontWithSize:18]];
    [self.operatorPhoneButton.titleLabel setFont:[Fonts regularFontWithSize:12.0f]];
    [self.operatorEmailButton.titleLabel setFont:[Fonts regularFontWithSize:12.0f]];

    
}


#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled: you cancelled the operation and no email message was queued.");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved: you saved the email message in the drafts folder.");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail send: the email message is queued in the outbox. It is ready to send.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed: the email message was not saved or queued, possibly due to an error.");
            break;
        default:
            NSLog(@"Mail not sent.");
            break;
    }
    // Remove the mail view
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
