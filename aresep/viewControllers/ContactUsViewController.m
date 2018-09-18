//
//  ContactUsViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "ContactUsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "Fonts.h"
#import "ActionSheetDatePicker.h"
#import "NSDate+Utils.h"
#import "NSString+Utils.h"
#import "AlertUtil.h"
#import "MReportIncident.h"


@interface ContactUsViewController ()

@property BOOL isBusRoute;

- (void) setFonts;

- (void) sendReportResponse;
- (void) sendReportResponseError;

@end

@implementation ContactUsViewController
@synthesize actionSheetDatePicker = _actionSheetDatePicker;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.busRoute = nil;
        self.isBusRoute = NO;
        self.trainRoute = nil;
        
        _report = [[MReportIncident  alloc] init];
       
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
        
        _report = [[MReportIncident  alloc] init];
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
        
        _report = [[MReportIncident  alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.selectedDate = [NSDate date];
    self.title = @"DENUNCIA";
    
    
    if (self.isBusRoute)
    {
        self.routeNameLabel.text = self.busRoute.routeName;
        [self.plateNumberTextField setHidden:NO];
          self.plateNumberTextField.text = @"";
    }
    else
    {
        self.routeNameLabel.text = self.trainRoute.routeName;
        [self.plateNumberTextField setHidden:YES];
        self.plateNumberTextField.text = @"Tren";
        
        CGRect frame = self.viewContent.frame;
        
        [self.viewContent setFrame: CGRectMake(frame.origin.x, frame.origin.y-30, frame.size.width, frame.size.height)];
    }
    
    [NotificationUtil connectNotification:@selector(sendReportResponse) toObject:self withNotificationName:REPORT_INCIDENT_DONE_EVENT];
    [NotificationUtil connectNotification:@selector(sendReportResponseError) toObject:self withNotificationName:REPORT_INCIDENT_ERROR_EVENT];
    
 
   
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setRadiusStyle:self.viewHeader];
    
    [self setFonts];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sendInfo:(id)sender
{
    
    if([self validateInfo])
    {
        NSNumber* routeId;
        NSString* routeName;
        
        if (self.isBusRoute)
        {
            routeId = self.busRoute.routeId;
            routeName = self.busRoute.routeName;
        }
        else
        {
            routeId = [NSNumber numberWithInt:1];
            routeName = self.busRoute.routeName;
        }
        [self.report reportIncidentWithName:self.fullNameTextField.text Id:self.idTextField.text phone:self.phoneNumberTextField.text email:self.emailTextField.text amount:self.ammountCharged.text date:[self.selectedDate stringDateWithServerFormat] plateNumber:self.plateNumberTextField.text routeId:routeId routeName:routeName];
        
    }
}

- (BOOL)validateInfo
{
    BOOL returnValue = YES;
    
    if([self.fullNameTextField.text isEmpty])
    {
         [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar su nombre completo" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
         returnValue = NO;
    }
    
    else if([self.idTextField.text isEmpty])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar su cédula" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    else if([self.phoneNumberTextField.text isEmpty])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar su teléfono" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    else if(![self.emailTextField.text isValidEmail])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar correo electrónico" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    else if([self.ammountCharged.text isEmpty])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar el monto que el cobraron" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    else if([self.dateTextField.text isEmpty])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar la fecha" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    else if([self.plateNumberTextField.text isEmpty])
    {
        [AlertUtil showErrorMessageInView:self.view withMessage:@"Debe de ingresar el número de placa" andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
        returnValue = NO;
    }
    
    return returnValue;
    
}


- (void)sendReportResponse
{
    
    RIButtonItem* action = [RIButtonItem item];;
    
    action.action = ^
    {
        [self.navigationController popViewControllerAnimated:YES];
    };
    
    [AlertUtil alertWithBlocks:@"Mi Ruta" withBody:@"Su denuncia ha sido enviada exitosamente" okAction:action];
 
}

- (void)sendReportResponseError
{
    [AlertUtil showErrorMessageInView:self.view withMessage:@"Error al ajecutar la operación, por favor intente de nuevo." andTitle:NSLocalizedString(@"Mi Ruta", @"Aresep")];
}

- (IBAction)selectADate:(id)sender {
    
    [self.view endEditing:YES];
    IQActionSheetPickerView *picker = [[IQActionSheetPickerView alloc] initWithTitle:@"" delegate:self];
    [picker setTag:6];
    [picker setActionSheetPickerStyle:IQActionSheetPickerStyleDatePicker];
    [picker show];
    
    //[self openDatePicker:sender];
}


-(void)actionSheetPickerView:(IQActionSheetPickerView *)pickerView didSelectDate:(NSDate *)date
{
    self.dateTextField.text = [date stringDateWithDefaultFormat];

}


- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    if([textField isEqual:self.dateTextField])
    {
        [self selectADate:self];
         return NO;
    }
    else
    {
        return YES;
    }
   
}


- (void) setFonts
{
    [self.routeNameLabel setFont:[Fonts boldFontWithSize:18.0f]];
    [self.routeTitleLabel setFont:[Fonts boldFontWithSize:18.0f]];
    [self.emailTextField setFont:[Fonts regularFontWithSize:15]];
    
    [self.fullNameTextField setFont:[Fonts regularFontWithSize:15]];
    [self.idTextField setFont:[Fonts regularFontWithSize:15]];
    [self.phoneNumberTextField setFont:[Fonts regularFontWithSize:15]];
    [self.emailTextField setFont:[Fonts regularFontWithSize:15]];
    [self.ammountCharged setFont:[Fonts regularFontWithSize:15]];
    [self.dateTextField setFont:[Fonts regularFontWithSize:15]];
    [self.plateNumberTextField setFont:[Fonts regularFontWithSize:15]];
    [self.personalInformationTitleLabel setFont:[Fonts boldFontWithSize:18]];
    [self.reportIncidentButton.titleLabel setFont:[Fonts regularFontWithSize:18]];
    
}

@end
