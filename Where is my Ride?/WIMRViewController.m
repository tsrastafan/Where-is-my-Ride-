//
//  WIMRViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRViewController.h"
#import "WIMRVehicle.h"

@interface WIMRViewController ()

@property (strong, nonatomic) WIMRLocationModel *locationManager;
@property (strong, nonatomic) WIMRVehicle *vehicle;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation WIMRViewController
- (IBAction)getLocation:(id)sender {
    [self.locationManager startStandardUpdates];
}

- (IBAction)shareLocation:(id)sender {
    [self.vehicle shareAnnotation];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.locationManager = [[WIMRLocationModel alloc] init];
    self.locationManager.delegate = self;
    self.vehicle = [[WIMRVehicle alloc] init];
    self.vehicle.title = @"Mein Fahrzeug";
    self.mapView.delegate = self;
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

/*! Inform the delegate that the location process has finished.
 *
 * Called for the delegate.
 * \param success A BOOL that determines wether the location update was successful.
 */
-(void)locationUpdateSuccessful:(BOOL)success
{
    if (success) {
        // update location label
        self.locationLabel.text = [[NSString alloc] initWithFormat:(@"latitude %+.6f\nlongitude %+.6f"),
                                   self.locationManager.lastLocation.coordinate.latitude,
                                   self.locationManager.lastLocation.coordinate.longitude];
        
        // center map around current location and zoom in
        MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.lastLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
        [self.mapView setRegion:region animated:YES];
        
        // remove old annotation
        [self.mapView removeAnnotation:self.vehicle];
        
        // set vehicle coordinate
        self.vehicle.coordinate = [self.locationManager.lastLocation coordinate];
        
        // add the annotation to the map view
        [self.mapView addAnnotation:self.vehicle];
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

- (MKAnnotationView *)mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    // If it's the user location, just return nil.
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[MKPointAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *thePinAnnotationView = (MKPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Here I am!"];
        
        if (!thePinAnnotationView)
        {
            // If an existing pin view was not available, create one.
            thePinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                                    reuseIdentifier:@"Here I am!"];
            thePinAnnotationView.animatesDrop = YES;
            thePinAnnotationView.canShowCallout = YES;
        }
        else
            thePinAnnotationView.annotation = annotation;
        
        return thePinAnnotationView;
    }
    
    return nil;
}


@end
