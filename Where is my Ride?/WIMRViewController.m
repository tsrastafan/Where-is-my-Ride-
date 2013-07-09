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
    [self.locationManager startLocationUpdate];
}

- (IBAction)shareLocation:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Mein Fahrzeug steht hier!";
    // Email Content
    NSString *messageBody = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@\n%@"),
                            self.locationManager.placemark.thoroughfare,
                            self.locationManager.placemark.subThoroughfare,
                            self.locationManager.placemark.postalCode,
                            self.locationManager.placemark.locality,
                            self.locationManager.placemark.administrativeArea];
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"steffenheberle@me.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
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
-(void)locationUpdateWithDesiredAccuracy:(BOOL)accurate{
    self.locationLabel.text = [[NSString alloc] initWithFormat:(@"latitude %+.6f\nlongitude %+.6f"),
                               self.locationManager.lastLocation.coordinate.latitude,
                               self.locationManager.lastLocation.coordinate.longitude];
    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationManager.lastLocation.coordinate, MKCoordinateSpanMake(0.01, 0.01));
    [self.mapView removeAnnotation:self.vehicle];
    [self.mapView setRegion:region animated:YES];
    self.vehicle.coordinate = self.locationManager.lastLocation.coordinate;
    [self.mapView addAnnotation:self.vehicle];
    if (accurate) {
        [self.locationManager stopLocationUpdate];
    }
}

- (void)reverseGeocodingCompleted:(BOOL)completed
{
    if (completed) {
        self.vehicle.placemark = self.locationManager.placemark;
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

#pragma mark - MFMailComposeViewControllerDelegate

- (void) mailComposeController:(MFMailComposeViewController *)controller
           didFinishWithResult:(MFMailComposeResult)result
                         error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
