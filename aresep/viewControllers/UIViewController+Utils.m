//
//  UIViewController+Utils.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "UIViewController+Utils.h"
#import "MBProgressHUD.h"
#import "AlertUtil.h"
#import "NotificationUtil.h"
#import "AppDelegate.h"
#import "EventMacros.h"
#import "ColorMacros.h"
#import "Colors.h"
#import "MGlobalVariables.h"
#import "Fonts.h"
#import "IOSVersion.h"

@implementation UIViewController (Utils)

- (void) initConnections
{
    
    [NotificationUtil connectNotification:@selector(hideProgressIndicatorFromNavController) toObject:self withNotificationName:HIDE_PROGRESS_INDICATOR];
    
    [NotificationUtil connectNotification:@selector(showConnectionError) toObject:self withNotificationName:CONNECTION_ERROR_EVENT];
    
    [NotificationUtil connectNotification:@selector(showProgressIndicatorOnNavController) toObject:self withNotificationName:SHOW_PROGRESS_INDICATOR];
    
    [NotificationUtil connectNotification:@selector(showProgressIndicatorWithTextOnNavController:) toObject:self withNotificationName:SHOW_PROGRESS_INDICATOR_WITH_TEXT];
    
    [NotificationUtil connectNotification:@selector(showAlertMessage:) toObject:self withNotificationName:SHOW_MESSAGE_EVENT];
    
    //[NotificationUtil connectNotification:@selector(logoutSuccesfull) toObject:self withNotificationName:LOGOUT_EVENT];
    
    if([self.navigationController.navigationBar respondsToSelector:@selector(setBarTintColor:)])
    {
        
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
        [self.navigationController.navigationBar setBarTintColor:[Colors navigationBarColor]];
        [self.navigationController.navigationBar setTranslucent:NO];
        self.navigationController.navigationBar.barStyle    = UIBarStyleBlackOpaque;
        [self.tabBarController.tabBar setTranslucent:NO];
        [self.tabBarController.tabBar setBarTintColor:[UIColor blackColor]];
        
        
        
        /*[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                              [UIColor whiteColor], NSForegroundColorAttributeName,
                                                              [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, [UIColor darkGrayColor], NSShadowAttributeName, [NSValue valueWithCGSize:CGSizeMake(0.0, -1.0)], NSShadowAttributeName,
                                                              nil]];
        */
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor darkGrayColor];
        shadow.shadowOffset = CGSizeMake(0.0, -1.0);
        NSDictionary *titleAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                         [UIColor whiteColor], NSForegroundColorAttributeName,
                                         [UIFont boldSystemFontOfSize:18.0f], NSFontAttributeName, shadow, NSShadowAttributeName,
                                         nil];
        
        [[UINavigationBar appearance] setTitleTextAttributes:titleAttributes];
        
        
    }
    else
    {
        [self.navigationController.navigationBar setTintColor:[Colors navigationBarColor]];
        [self.navigationController.toolbar setTintColor:[Colors navigationBarColor]];
    }
}


- (void) removeConnections
{
    [NotificationUtil disconectNotification:self withNotificationName:HIDE_PROGRESS_INDICATOR];
    
    [NotificationUtil disconectNotification:self withNotificationName:CONNECTION_ERROR_EVENT];
    
    [NotificationUtil disconectNotification:self withNotificationName:SHOW_PROGRESS_INDICATOR];
    
    [NotificationUtil disconectNotification:self withNotificationName:SHOW_PROGRESS_INDICATOR_WITH_TEXT];
    
    [NotificationUtil disconectNotification:self withNotificationName:SHOW_MESSAGE_EVENT];
    
    //[NotificationUtil disconectNotification:self withNotificationName:LOGOUT_EVENT];
    
}


-(void) setDefaultBackgroundImage
{
    UIImageView *backgroundImage = nil;
    
    if (![self isiPhone5])
    {
        backgroundImage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg"]];
    }
    else
    {
        backgroundImage= [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg-568h"]];
    }
    
    CGRect bounds = [[UIScreen mainScreen] bounds];
    backgroundImage.frame = bounds;
    
    [self.view addSubview:backgroundImage];
    [self.view sendSubviewToBack:backgroundImage];
}

- (void)showProgressIndicator
{
    if ([self isViewVisible])
    {
        
        if (![MBProgressHUD HUDForView:self.view])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
        }
    }
}


//- (void)showProgressIndicatorOnTabBar
//{
//    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//
//    // ASV - Only show if the view does not have a progress indicator already.
//    if (![MBProgressHUD HUDForView:appDelegate.tabBarController.view])
//    {
//        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:appDelegate.tabBarController.view animated:YES];
//        hud.dimBackground = YES;
//    }
//}

- (void)showProgressIndicatorOnNavController
{
    // ASV - Only show if the view does not have a progress indicator already.
    if ([self isViewVisible])
    {
        if (![MBProgressHUD HUDForView:self.navigationController.view])
        {
            if(self.navigationController.view)
            {
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.dimBackground = YES;
            }
        }
        
    }
}

- (void)showProgressIndicatorWithText:(NSString *)text andDescription:(NSString *)description
{
    if ([self isViewVisible])
    {
        if (![MBProgressHUD HUDForView:self.view])
        {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.dimBackground = YES;
            
            hud.labelText = text;
            hud.detailsLabelText = description;
            hud.square = YES;
        }
    }
}

- (void)showProgressIndicatorWithTextOnNavController:(NSNotification *)notification
{
    if ([self isViewVisible])
    {
        if (![MBProgressHUD HUDForView:self.navigationController.view])
        {
            
            if(self.navigationController.view)
            {
                NSDictionary *dict = [notification userInfo];
                
                NSString * message = [dict objectForKey:@"message"];
                
                NSString * title = [dict objectForKey:@"title"];
                
                MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
                hud.dimBackground = YES;
                
                hud.labelText = title;
                hud.detailsLabelText = message;
                hud.square = YES;
            }
        }
    }
}

- (void)hideProgressIndicator
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}



//- (void)hideProgressIndicatorFromTabBar
//{
//    AppDelegate* appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
//    [MBProgressHUD hideHUDForView:appDelegate.tabBarController.view animated:YES];
//}

- (void)showAlertMessage:(NSNotification *)notification
{
    if ([self isViewVisible])
    {
        if (self.navigationController.view)
        {
            NSDictionary *dict = [notification userInfo];
            
            NSString * message = [dict objectForKey:@"message"];
            
            NSString * title = [dict objectForKey:@"title"];
            
            [AlertUtil alert:title withBody:message firstButtonNamed:@"OK" andDelegate:nil tag:0];
        }
    }
}

- (void)hideProgressIndicatorFromNavController
{
    if ([self isViewVisible])
    {
        if (self.navigationController.view)
        {
            if ([MBProgressHUD HUDForView:self.navigationController.view])
            {
                [MBProgressHUD hideHUDForView:self.navigationController.view animated:YES];
            }
        }
    }
}

- (void)showConnectionError
{
    if ([self isViewVisible])
    {
        
        [self hideProgressIndicatorFromNavController];
        
        if(![MGlobalVariables getInstance].errorMessageShown)
        {
            [MGlobalVariables getInstance].errorMessageShown = YES;
            [AlertUtil alert:@"Error de Conexión" withBody: @"Oops, Ha ocurrido un problema, por favor verifica tu conexión a Internet" firstButtonNamed:@"OK" andDelegate:self tag:9001];
        }
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 9001)
    {
        [MGlobalVariables getInstance].errorMessageShown = NO;
    }
}


- (void)popToRootViewController
{
    if (self.navigationController)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

- (void)popToSpecificViewController: (int)viewPosition
{
    if (self.navigationController)
    {
        // Pop the view controller to root only if it is at the top.
        NSArray *array = [self.navigationController viewControllers];
        
        [self.navigationController popToViewController:[array objectAtIndex:viewPosition] animated:YES];
    }
}

-(void)popViewController
{
    if (self.navigationController)
    {
        // Pop the view controller to root only if it is at the top.
        if ([self.navigationController.topViewController isEqual:self])
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

- (void)scrollViewToTextField:(id)textField inTableView:(UITableView *)tableView
{
    UITableViewCell *cell = nil;
    if ([textField isKindOfClass:[UITextField class]])
        cell = (UITableViewCell *) ((UITextField *) textField).superview.superview;
    else if ([textField isKindOfClass:[UITextView class]])
        cell = (UITableViewCell *) ((UITextView *) textField).superview.superview;
    NSIndexPath *indexPath = [tableView indexPathForCell:cell];
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
}


-(void)addToolbarButton:(NSString *)title  target:(id)target action:(SEL)action toTheRight:(BOOL)right
{
    
    UIBarButtonItem *flexibleSpaceLeft = nil;
    
    //CGSize expectedSize = [title sizeWithFont:[UIFont boldSystemFontOfSize:13.0f]];
    CGSize maximumDetailLabelSize = CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX);
    
    CGRect expectedSizeRect = [title boundingRectWithSize:maximumDetailLabelSize
                                                              options:NSStringDrawingUsesLineFragmentOrigin| NSStringDrawingUsesFontLeading
                                                           attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13.0f]}
                                                              context:nil];
    
    UIButton *colorButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (expectedSizeRect.size.width + 20), 31)];
    
    [colorButton addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [colorButton setTitle:title forState:UIControlStateNormal];
    [colorButton setBackgroundImage:[UIImage imageNamed:@"navigationButton"] forState:UIControlStateNormal];
    
    colorButton.titleLabel.font = [UIFont boldSystemFontOfSize:13.0f];
    
    
    UIBarButtonItem * button = [[UIBarButtonItem alloc] initWithCustomView:colorButton];
    
    if(right)
    {
        
        flexibleSpaceLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        self.toolbarItems = [ NSArray arrayWithObjects:flexibleSpaceLeft,button,nil];
        
    }
    else
    {
        self.toolbarItems = [ NSArray arrayWithObject:button];
    }
    
    
    
}



-(void)addNavigationButtonLeft:(NSString *)title  target:(id)target action:(SEL)action
{

    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle: title style: UIBarButtonItemStylePlain target: target action: action];
    
    self.navigationItem.leftBarButtonItem = newButton;
    
}

-(void)addNavigationButtonRight:(NSString *)title  target:(id)target action:(SEL)action
{
    UIBarButtonItem *newButton = [[UIBarButtonItem alloc] initWithTitle: title style: UIBarButtonItemStylePlain target: target action: action];
    
    self.navigationItem.rightBarButtonItem = newButton;
    
}

-(void)addNavigationRefreshButtonRightWithtarget:(id)target action:(SEL)action
{
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 35, 31)];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [button setBackgroundImage:[UIImage imageNamed:@"navigationRefreshButton"] forState:UIControlStateNormal];
    
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = rightButton;
    
    
}

-(BOOL)isViewVisible
{
    return (self.isViewLoaded && self.view.window);
}



-(void)setStyledBackButton
{
    
    UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Atrás" style: UIBarButtonItemStylePlain target: nil action: nil];
    
    self.navigationItem.backBarButtonItem = newBackButton;
    
}


-(void)setStyledBackButtonWithTarget:(id)target action:(SEL)action
{
    
    if(![IOSVersion isIOS7])
    {
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 59, 31)];
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
        [button setTitle:@" Atrás" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"backButton"] forState:UIControlStateNormal];
        button.titleLabel.font = [Fonts boldFontWithSize:13];
        
        UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
        
        self.navigationItem.leftBarButtonItem = buttonItem;
        
    }
    else
    {
        
        UIBarButtonItem *newBackButton = [[UIBarButtonItem alloc] initWithTitle: @"Atrás" style: UIBarButtonItemStylePlain target: target action: action];
    
        self.navigationItem.backBarButtonItem = newBackButton;
        
    }
    
    
}

-(void)setRadiusStyle:(UIView *)view
{
    //view.layer.borderWidth = 1;
    //view.layer.borderColor = [[UIColor grayColor] CGColor];
    view.layer.cornerRadius = 2;
}

- (BOOL) isiPhone5
{
    CGRect bounds = [[UIScreen mainScreen] bounds];
    CGFloat height = bounds.size.height;
    CGFloat scale = [[UIScreen mainScreen] scale];
    
    return (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) && ((height * scale) >= 1136));
}

@end
