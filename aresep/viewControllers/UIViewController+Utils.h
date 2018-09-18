//
//  UIViewController+Utils.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Utils)

- (void) initConnections;

- (void) removeConnections;

- (void) showProgressIndicator;

- (void) showProgressIndicatorOnNavController;

- (void) showAlertMessage:(NSNotification *)notification;

- (void) showProgressIndicatorWithText:(NSString *)text andDescription:(NSString *)description;

- (void) showProgressIndicatorWithTextOnNavController:(NSString *)text;

- (void) hideProgressIndicator;

- (void) hideProgressIndicatorFromNavController;

- (void) showConnectionError;

- (void) setDefaultBackgroundImage;

- (void) popToRootViewController;

- (void) scrollViewToTextField:(id)textField inTableView:(UITableView *)tableView;

- (void) addToolbarButton:(NSString *)title  target:(id)target action:(SEL)action toTheRight:(BOOL)right;

- (void) addNavigationButtonLeft:(NSString *)title  target:(id)target action:(SEL)action;

- (void) addNavigationButtonRight:(NSString *)title  target:(id)target action:(SEL)action;

- (void) addNavigationRefreshButtonRightWithtarget:(id)target action:(SEL)action;

- (void) popViewController;

- (void) popToSpecificViewController: (int)viewPosition;

- (void) setStyledBackButton;

- (void) setStyledBackButtonWithTarget:(id)target action:(SEL)action;

- (BOOL) isViewVisible;

- (BOOL) isiPhone5;

- (void) setRadiusStyle:(UIView *)view;

@end
