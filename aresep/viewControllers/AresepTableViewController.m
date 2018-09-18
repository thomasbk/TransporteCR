//
//  AresepTableViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 13/08/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepTableViewController.h"

@interface AresepTableViewController ()

@end

@implementation AresepTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initConnections];
    
    [self setDefaultBackgroundImage];  
    
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
    [self removeConnections];
    
    // Do any additional setup after loading the view from its nib.
}

@end
