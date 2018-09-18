//
//  ChatViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 28/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"

@interface ChatViewController : AresepViewController <UIWebViewDelegate>

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
