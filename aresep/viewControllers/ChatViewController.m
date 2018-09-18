//
//  ChatViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 28/10/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "ChatViewController.h"
#import "Constants.h"

#define ADDRESS_URL     @"http://chat-usuario.aresep.go.cr/chat.php?code=U0VSVkVSUEFHRQ"

@interface ChatViewController ()

@end

@implementation ChatViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Chat"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setStyledBackButton];
    
    NSString *urlAddress = [NSString stringWithFormat:ADDRESS_URL];
    
    NSLog(@"URL TO OPEN %@",urlAddress);
    //Create a URL object.
    NSURL *url = [NSURL URLWithString:urlAddress];
    
    //URL Requst Object
    NSURLRequest *requestObj = [NSURLRequest requestWithURL:url];
    
    //Load the request in the UIWebView.
    [self.webView loadRequest:requestObj];
    
    
}


- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showProgressIndicator];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self hideProgressIndicator];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showProgressIndicator];
    [self showConnectionError];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
