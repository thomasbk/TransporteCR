//
//  AlertUtil.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RIButtonItem.h"

@interface AlertUtil : NSObject

+(void)alert:(NSString *)title withBody:(NSString *)message firstButtonNamed:(NSString *)firstButtonName andDelegate:(id)delegate tag:(int)tag;

+(void)yesNoAlert:(NSString*)title withBody:(NSString*)message withDelegate:(id)delegate tag:(int)tag;

+(void)yesNoAlertWithBlocks:(NSString*)title withBody:(NSString*)message cancelAction:(RIButtonItem *)cancel okAction:(RIButtonItem *)ok;

+(void)alertWithBlocks:(NSString*)title withBody:(NSString*)message okAction:(RIButtonItem *)ok;

+(void)showErrorMessageInView:(UIView *)view withMessage:(NSString *)message andTitle:(NSString *)messageTitle;

+(void)showNotificationMessageInView:(UIView *)view withMessage:(NSString *)message;

@end
