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

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
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
    self.mapView.delegate = self;
    
    //self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    NSLog(@"***DID RECEIVE MEMORY WARNING");
    // Dispose of any resources that can be recreated.
}

- (void)updateView
{
    
}

#pragma mark - WIMRLocationModelDelegate

/*! Inform the delegate that the location process has finished.
 *
 * Called for the delegate.
 * \param success A BOOL that determines wether the location update was successful.
 */
-(void)locationUpdateSuccessful:(BOOL)success
{
    if (success) {
        self.locationLabel.text = [[NSString alloc] initWithFormat:(@"latitude %+.6f\nlongitude %+.6f"),
                                   self.locationManager.lastLocation.coordinate.latitude,
                                   self.locationManager.lastLocation.coordinate.longitude];
        MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.lastLocation.coordinate, MKCoordinateSpanMake(1, 1));
        [self.mapView setRegion:region animated:YES];
        //[self.mapView setCenterCoordinate:self.locationManager.lastLocation.coordinate animated:YES];

    }
}

- (void)reverseGeocodingCompleted:(BOOL)completed
{
    if (completed) {
        self.addressLabel.text = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@\n%@"),
                                  self.locationManager.placemark.thoroughfare,
                                  self.locationManager.placemark.subThoroughfare,
                                  self.locationManager.placemark.postalCode,
                                  self.locationManager.placemark.locality,
                                  self.locationManager.placemark.administrativeArea];
    }

}

#pragma mark - MKMapViewDelegate





@end
