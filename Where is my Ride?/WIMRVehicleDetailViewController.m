//
//  WIMRViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleDetailViewController.h"
#import "WIMRVehicleModel.h"



@interface WIMRVehicleDetailViewController ()

@property (strong, nonatomic) WIMRLocationModel *locationModel;
@property (strong, nonatomic) WIMRVehicleModel *vehicle;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@property (strong, nonatomic) NSManagedObjectContext *context;



@end

@implementation WIMRVehicleDetailViewController


- (WIMRVehicleModel *)vehicle
{
    if (!_vehicle) _vehicle = [[WIMRVehicleModel alloc] init];
    return _vehicle;
}

- (NSManagedObjectContext *)context
{
    if (!_context) _context = self.managedObject.managedObjectContext;
    return _context;
}


- (BOOL)saveVehicleState
{
    self.managedObject.longitude = [NSNumber numberWithDouble:self.locationModel.lastLocation.coordinate.longitude];
    self.managedObject.type = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:[self.typeTextField.text intValue]];
    self.managedObject.latitude = [NSNumber numberWithDouble:self.locationModel.lastLocation.coordinate.latitude];
    self.managedObject.altitude = [NSNumber numberWithDouble:self.locationModel.lastLocation.altitude];
    self.managedObject.horizontalAccuracy = [NSNumber numberWithDouble:self.locationModel.lastLocation.horizontalAccuracy];
    
    [self.managedObject setValue:[NSNumber numberWithDouble:self.locationModel.lastLocation.verticalAccuracy] forKey:@"verticalAccuracy"];
    [self.managedObject setValue:[NSNumber numberWithDouble:self.locationModel.lastLocation.course] forKey:@"course"];
    [self.managedObject setValue:[NSNumber numberWithDouble:self.locationModel.lastLocation.speed] forKey:@"speed"];
    [self.managedObject setValue:self.locationModel.lastLocation.timestamp forKey:@"timestamp"];
    
    
    [self.managedObject setValue:self.textField.text forKey:@"name"];
    
    
    
    
    NSError *error = nil;
    
    if (![self.context save:&error]) {
        NSLog(@"Error");
    }
    
    return !error;
    
}

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"E-Mail", nil];
    [shareSheet showFromBarButtonItem:sender animated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self shareLocation:nil];
            break;
        case 1:
            break;
    }
}


- (IBAction)getLocation:(id)sender {
    [self.locationModel startLocationUpdate];
    self.locationLabel.text = @"Updating ...";
    self.addressLabel.text = @"Updating ...";
}



/*! Shares the Location.
 *
 *  The location is shared, at the moment only via email.
 */
- (IBAction)shareLocation:(id)sender {
    // Email Subject
    NSString *emailTitle = @"Mein Fahrzeug steht hier!";
    // Email Content
    NSString *messageBody = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@\n%@"),
                            self.locationModel.placemark.thoroughfare,
                            self.locationModel.placemark.subThoroughfare,
                            self.locationModel.placemark.postalCode,
                            self.locationModel.placemark.locality,
                            self.locationModel.placemark.administrativeArea];
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
    
    self.locationModel = [[WIMRLocationModel alloc] init];
    self.locationModel.delegate = self;
    self.mapView.delegate = self;
    self.textField.delegate = self;
    self.textField.text = [self.managedObject.name description];
    self.typeTextField.delegate = self;
    self.typeTextField.text = [self.managedObject.type description];
    
    
    //load last location from CoreData
    // this mehtod should be discussed!
    
#warning Model design, shoud this method be changed
    
    [self.locationModel setLastLocationLatitude:self.managedObject.latitude longitude:self.managedObject.longitude altitude:self.managedObject.altitude horizontalAccuracy:self.managedObject.horizontalAccuracy verticalAccuracy:self.managedObject.verticalAccuracy course:self.managedObject.course speed:self.managedObject.speed timestamp:self.managedObject.timestamp];
    
    
    //Toolbar Buttons
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    UIBarButtonItem *getLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getLocation:)];
    UIBarButtonItem *takePhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    UIBarButtonItem *takeNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:nil];
    UIBarButtonItem *setParkTimeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil];
    UIBarButtonItem *systemActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    [self setToolbarItems:@[getLocationButton, flexibleSpaceButton, takePhotoButton, flexibleSpaceButton, takeNoteButton, flexibleSpaceButton, setParkTimeButton, flexibleSpaceButton,systemActionButton] animated:YES];
    
    [self updateUI];
    
}


- (void)updateUI
{
    self.vehicle.coordinate = self.locationModel.lastLocation.coordinate;
    MKCoordinateRegion region = MKCoordinateRegionMake(self.locationModel.lastLocation.coordinate, MKCoordinateSpanMake(0.005, 0.005));
    [self.mapView removeAnnotation:self.vehicle];
    [self.mapView setRegion:region animated:YES];
    [self.mapView addAnnotation:self.vehicle];
    [self.mapView removeOverlay:[self.mapView.overlays lastObject]];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:self.locationModel.lastLocation.coordinate radius:self.locationModel.lastLocation.horizontalAccuracy]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - WIMRLocationModelDelegate

/*! Inform the delegate that the location process has finished.
 *
 * Called for the delegate.
 * \param success A BOOL that determines whether the location update was successful.
 */
- (void)didUpdateLocation:(BOOL)success withStatus:(LocationUpdateReturnStatus)status
{
    if (success) {
        [self updateUI];
        
        [self saveVehicleState];
        
    } else {
        self.locationLabel.text = @"Could not get update.";
    }
}


- (void)didFinishReverseGeocoding:(BOOL)success
{
    if (success) {
        self.vehicle.placemark = self.locationModel.placemark;
        self.addressLabel.text = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@\n%@"),
                                  self.locationModel.placemark.thoroughfare,
                                  self.locationModel.placemark.subThoroughfare,
                                  self.locationModel.placemark.postalCode,
                                  self.locationModel.placemark.locality,
                                  self.locationModel.placemark.administrativeArea];
    } else {
        self.addressLabel.text = @"Could not get corresponding address.";
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
        MKPinAnnotationView *thePinAnnotationView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Vehicle"];
        
        if (!thePinAnnotationView)
        {
            // If an existing pin view was not available, create one.
            thePinAnnotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Vehicle"];
            thePinAnnotationView.animatesDrop = YES;
            thePinAnnotationView.canShowCallout = YES;
        
        }
        else {
            thePinAnnotationView.annotation = annotation;
        }
        
        return thePinAnnotationView;
    }
    
    return nil;
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:[MKCircle circleWithCenterCoordinate:self.locationModel.lastLocation.coordinate radius:self.locationModel.lastLocation.horizontalAccuracy]];
    //circleRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.2];
    circleRenderer.strokeColor = [UIColor redColor];
    circleRenderer.lineWidth = 1;
    return circleRenderer;
}

/*
- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    MKCircleView *circleView = [[MKCircleView alloc] initWithOverlay:overlay];
    circleView.strokeColor = [UIColor redColor];
    circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    return circleView;
}
 */

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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
  /*  [self.managedObject setValue:self.textField.text forKey:@"name"];
    NSError *error;
    
    if (![self.context save:&error]) {
        NSLog(@"Error");
    }
*/    
    return [textField resignFirstResponder];
}

@end
