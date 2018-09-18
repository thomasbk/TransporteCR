//
//  InformationViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 02/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "InformationViewController.h"
#import "ChatViewController.h"
#import "IOSVersion.h"
#import "Colors.h"
#import "Fonts.h"

@interface InformationViewController ()

- (void) closeModal;
- (IBAction)call:(id)sender;
- (IBAction)sendEmail:(id)sender;
- (IBAction)showWebSite:(id)sender;
- (IBAction)showFacebook:(id)sender;
- (IBAction)showTwitter:(id)sender;
- (IBAction)showChat:(id)sender;


- (void) setFonts;

@end

@implementation InformationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setTitle:@"Información"];
    
    [self setRadiusStyle:self.viewContent];
    
    [self addNavigationButtonLeft:@"Cerrar" target:self action:@selector(closeModal)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) closeModal
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)call:(id)sender
{
    NSString* callNumber = @"8000273737";
    
    NSString* callString = [NSString stringWithFormat:@"Tel:%@",callNumber];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:callString]];
}

- (IBAction)sendEmail:(id)sender
{
    if ([MFMailComposeViewController canSendMail])
    {
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        
       
        NSArray *toRecipients = [NSArray arrayWithObjects:@"usuario@aresep.go.cr", nil];
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
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ARESEP"
                                                        message:@"Debes tener alguna cuenta de correo configurada en tu dispositivo"
                                                       delegate:nil
                                              cancelButtonTitle:@"Aceptar"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)showWebSite:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.aresep.go.cr"]];
}

- (IBAction)showFacebook:(id)sender
{
    BOOL facebbok = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/310345779008496"]];
    
    if (facebbok)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"fb://profile/310345779008496"]];
    } else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Aresep/310345779008496"]];
    }

}

- (IBAction)showTwitter:(id)sender
{
    BOOL twitter = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=CrAresep"]];
    
    if (twitter)
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"twitter://user?screen_name=CrAresep"]];
    } else
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/CrAresep"]];
    }
}

- (IBAction)showChat:(id)sender
{
    ChatViewController *view = [[ChatViewController alloc] initWithNibName:@"ChatViewController" bundle:nil];
    
    [self.navigationController pushViewController:view animated:YES];
    
    
    
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

- (void) setFonts
{
    [[self.phoneButton titleLabel] setFont:[Fonts boldFontWithSize:20.0f]];
    [[self.emailButton titleLabel] setFont:[Fonts boldFontWithSize:20.0f]];
    [[self.webButton titleLabel] setFont:[Fonts boldFontWithSize:20.0f]];
    [[self.facebookButton titleLabel] setFont:[Fonts boldFontWithSize:20.0f]];
    [[self.twitterButton titleLabel] setFont:[Fonts boldFontWithSize:20.0f]];
    [[self.chatButton titleLabel] setFont:[Fonts boldFontWithSize:20]];
}

@end
