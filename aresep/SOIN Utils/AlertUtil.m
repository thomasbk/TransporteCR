//
//  AlertUtil.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AlertUtil.h"
#import "UIAlertView+Blocks.h"
#import "WBSuccessNoticeView.h"
#import "WBErrorNoticeView.h"

@implementation AlertUtil

+(void)alert:(NSString *)title withBody:(NSString *)message firstButtonNamed:(NSString *)firstButtonName  andDelegate:(id)delegate tag:(int)tag{
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle: title
                          message: message
                          delegate: delegate
                          cancelButtonTitle: firstButtonName
                          otherButtonTitles: nil];
    
    alert.tag = tag;
    
    [alert show];
}

+(void)yesNoAlert:(NSString*)title withBody:(NSString*)message withDelegate:(id)delegate tag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate: delegate
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Si", nil];
    alert.tag = tag;
    
    [alert setAlertViewStyle:UIAlertViewStylePlainTextInput];
    
    [alert show];
}




+(void)yesNoAlertWithTextField:(NSString*)title body:(NSString*)message alertStyle:(UIAlertViewStyle)alertStyle delegate:(id)delegate andTag:(int)tag
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle: title
                                                    message: message
                                                   delegate: delegate
                                          cancelButtonTitle: @"No"
                                          otherButtonTitles: @"Si", nil];
    alert.tag = tag;
    
    alert.alertViewStyle = alertStyle;
    
    [alert show];
}

+(void)yesNoAlertWithBlocks:(NSString*)title withBody:(NSString*)message cancelAction:(RIButtonItem *)cancel okAction:(RIButtonItem *)ok
{
    RIButtonItem *cancelItem =cancel;
    
    if(cancelItem == nil)
    {
        cancelItem = [RIButtonItem item];
    }
    
    cancelItem.label = @"No";
    ok.label = @"Si";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:cancelItem
                                               otherButtonItems:ok, nil];
    [alertView show];
}

+(void)alertWithBlocks:(NSString*)title withBody:(NSString*)message okAction:(RIButtonItem *)ok
{
    ok.label = @"OK";
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                               cancelButtonItem:nil
                                               otherButtonItems:ok, nil];
    [alertView show];
    
    
}

+(void)showErrorMessageInView:(UIView *)view withMessage:(NSString *)message andTitle:(NSString *)messageTitle
{
    //    WBNoticeView *nm = [WBNoticeView defaultManager];
    //    [nm showErrorNoticeInView:view title:messageTitle message:message];
    
    WBErrorNoticeView *notice = [WBErrorNoticeView errorNoticeInView:view title:messageTitle message:message];
    
    [notice show];
    
}


+(void)showNotificationMessageInView:(UIView *)view withMessage:(NSString *)message
{
    WBSuccessNoticeView *notice = [WBSuccessNoticeView successNoticeInView:view title:message];
    [notice show];
}

@end
