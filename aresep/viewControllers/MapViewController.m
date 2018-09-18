//
//  MapViewController.m
//  aresep
//
//  Created by Christopher Jimenez on 10/2/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "MapViewController.h"

@interface MapViewController ()

@end

@implementation MapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mapURL:(NSString *)mapURL
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.mapURL = mapURL;
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addNavigationButtonLeft:@"Cerrar" target:self action:@selector(closeModal)];
    
    self.imageView.placeholderImage = [UIImage imageNamed:@"loadingPlaceHolderImage"];
    self.imageView.imageURL = [[NSURL alloc] initWithString:self.mapURL];
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void) closeModal
{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
