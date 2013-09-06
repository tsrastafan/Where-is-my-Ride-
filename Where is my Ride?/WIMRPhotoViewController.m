//
//  WIMRPhotoViewController.m
//  Where is my Ride?
//
//  Created by Steffen Heberle on 30.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRPhotoViewController.h"
#import "WIMRVehicleDataModel.h"

@interface WIMRPhotoViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end


@implementation WIMRPhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSMutableArray *photos = self.vehicle.photos;
    if ([photos count] > 0)
    {
        if ([photos count] == 1)
        {
            // Camera took a single picture.
            [self.imageView setImage:[photos objectAtIndex:0]];
        }
        else
        {
            // Camera took multiple pictures; use the list of images for animation.
            self.imageView.animationImages = photos;
            self.imageView.animationDuration = 5.0;    // Show each captured photo for 5 seconds.
            self.imageView.animationRepeatCount = 0;   // Animate forever (show all photos).
            [self.imageView startAnimating];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
