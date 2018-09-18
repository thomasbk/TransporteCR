//
//  ContactUsViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"
#import "UIPlaceHolderTextView.h"
#import "Bus_Routes.h"
#import "Train_Routes.h"
#import "TPKeyboardAvoidingScrollView.h"
#import "MReportIncident.h"
#import "IQActionSheetPickerView.h"

@class ActionSheetDatePicker;

@interface ContactUsViewController : AresepViewController <UITextFieldDelegate,IQActionSheetPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *viewHeader;
@property (weak, nonatomic) IBOutlet UIView *viewContent;

@property (weak, nonatomic) IBOutlet UILabel *routeNameLabel;

@property (weak, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *idTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *ammountCharged;
@property (weak, nonatomic) IBOutlet UITextField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *plateNumberTextField;
@property (weak, nonatomic) IBOutlet TPKeyboardAvoidingScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UILabel *routeTitleLabel;
@property (strong, nonatomic) MReportIncident * report;

- (IBAction)selectADate:(id)sender;


@property (nonatomic, strong) NSDate * selectedDate;

@property (nonatomic, strong) ActionSheetDatePicker * actionSheetDatePicker;


@property (nonatomic, strong) Bus_Routes* busRoute;
@property (nonatomic, strong) Train_Routes* trainRoute;

@property (weak, nonatomic) IBOutlet UIButton *reportIncidentButton;
@property (weak, nonatomic) IBOutlet UILabel *personalInformationTitleLabel;

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
          withBusRoute:(Bus_Routes*)aBusRoute;

- (id) initWithNibName:(NSString *)nibNameOrNil
                bundle:(NSBundle *)nibBundleOrNil
        withTrainRoute:(Train_Routes*)aTrainRoute;

@end
