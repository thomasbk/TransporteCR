//
//  CJZBarReaderViewController.m
//  aresep
//
//  Created by Christopher Jimenez on 10/30/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "CJZBarReaderViewController.h"

@interface CJZBarReaderViewController ()

@end

@implementation CJZBarReaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void) loadView
{
    self.view = [[[UIView alloc] initWithFrame: CGRectMake(0, 0, 320, 480)] autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
