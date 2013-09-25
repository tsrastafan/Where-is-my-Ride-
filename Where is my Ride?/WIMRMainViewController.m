//
//  WIMRMainViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 9/25/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRMainViewController.h"
#import "TSSHCenterViewController.h"

#import <QuartzCore/QuartzCore.h>

@interface WIMRMainViewController () <TSSHCenterViewControllerDelegate>

@end

@implementation WIMRMainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
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
