//
//  InformationViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"
#import "MessageUI/MessageUI.h"

@interface InformationViewController : AresepViewController <MFMailComposeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UIButton *emailButton;
@property (weak, nonatomic) IBOutlet UIButton *webButton;
@property (weak, nonatomic) IBOutlet UIButton *facebookButton;
@property (weak, nonatomic) IBOutlet UIView *viewContent;
@property (weak, nonatomic) IBOutlet UIButton *twitterButton;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@end
