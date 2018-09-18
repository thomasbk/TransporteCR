//
//  MapViewController.h
//  aresep
//
//  Created by Christopher Jimenez on 10/2/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EGOImageView.h"
#import "AresepViewController.h"

@interface MapViewController : AresepViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil mapURL:(NSString *)mapURL;

@property (nonatomic, strong) NSString * mapURL;

@property (weak, nonatomic) IBOutlet EGOImageView *imageView;

@end
