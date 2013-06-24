//
//  WIMRViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRViewController.h"

@interface WIMRViewController ()

@property (strong, nonatomic) WIMRLocationModel *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@end

@implementation WIMRViewController
- (IBAction)getLocation:(id)sender {
    [self.locationManager startStandardUpdates];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[WIMRLocationModel alloc] init];
    self.locationManager.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateView
{
    
}

#pragma mark - WIMRLocationModelDelegate

-(void)locationUpdateSuccessful:(BOOL)success
{
    if (success) {
        self.locationLabel.text = [[NSString alloc] initWithFormat:(@"latitude %+.6f, longitude %+.6f\n"),
                                   self.locationManager.lastLocation.coordinate.latitude,
                                   self.locationManager.lastLocation.coordinate.longitude];
        self.addressLabel.text = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@ %@"),
                                  self.locationManager.placemark.subThoroughfare,
                                  self.locationManager.placemark.thoroughfare,
                                  self.locationManager.placemark.locality,
                                  self.locationManager.placemark.administrativeArea,
                                  self.locationManager.placemark.postalCode];
    }
}

- (void)reverseGeocodingCompleted:(BOOL)completed
{
    if (completed) {
        self.addressLabel.text = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@ %@"),
                                  self.locationManager.placemark.subThoroughfare,
                                  self.locationManager.placemark.thoroughfare,
                                  self.locationManager.placemark.locality,
                                  self.locationManager.placemark.administrativeArea,
                                  self.locationManager.placemark.postalCode];
    }

}
@end
