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

@property (strong, nonatomic) TSSHLocationManager *locationManager;
@property (strong, nonatomic) WIMRVehicleModel *vehicle;
@property (strong, nonatomic) NSManagedObjectContext *context;

@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end


@implementation WIMRVehicleDetailViewController

- (TSSHLocationManager *)locationManager
{
    if (!_locationManager) _locationManager = [[TSSHLocationManager alloc] init];
    return _locationManager;
}

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.vehicle.location = [NSKeyedUnarchiver unarchiveObjectWithData:self.managedObject.location];
    self.vehicle.placemark = [NSKeyedUnarchiver unarchiveObjectWithData:self.managedObject.placemark];
    self.vehicle.title = self.managedObject.title;
    
    // set delegates
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.textField.delegate = self;
    self.typeTextField.delegate = self;
    
    [self createToolbarButtons];
    
    [self updateUI];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Tools

- (void)updateUI
{
    self.locationLabel.text = [[NSString alloc] initWithFormat:(@"long.: %g lat.: %g"),
                               self.vehicle.coordinate.longitude,
                               self.vehicle.coordinate.latitude];
    self.addressLabel.text = [[NSString alloc] initWithFormat:(@"%@ %@\n%@ %@\n%@"),
                              self.vehicle.placemark.thoroughfare,
                              self.vehicle.placemark.subThoroughfare,
                              self.vehicle.placemark.postalCode,
                              self.vehicle.placemark.locality,
                              self.vehicle.placemark.administrativeArea];
    
    self.textField.text = self.vehicle.title;
    self.typeTextField.text = [self.managedObject.type description];
    
    MKCoordinateRegion region = MKCoordinateRegionMake(self.vehicle.coordinate, MKCoordinateSpanMake(0.005, 0.005));
    [self.mapView setRegion:region animated:YES];
    [self.mapView removeOverlay:[self.mapView.overlays lastObject]];
    [self.mapView removeAnnotation:self.vehicle];
    [self.mapView addAnnotation:self.vehicle];
    [self.mapView addOverlay:[MKCircle circleWithCenterCoordinate:self.vehicle.coordinate radius:self.vehicle.location.horizontalAccuracy]];
}

- (BOOL)saveVehicleStatus
{
    self.managedObject.location = [NSKeyedArchiver archivedDataWithRootObject:self.vehicle.location];
    self.managedObject.placemark = [NSKeyedArchiver archivedDataWithRootObject:self.vehicle.placemark];
    self.managedObject.title = self.textField.text;
    self.managedObject.type = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:[self.typeTextField.text intValue]];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Error");
    }
    
    return !error;
}

- (void)createToolbarButtons
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    UIBarButtonItem *getLocationButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(getLocation:)];
    UIBarButtonItem *takePhotoButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera target:self action:nil];
    UIBarButtonItem *takeNoteButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:nil];
    UIBarButtonItem *setParkTimeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:nil];
    UIBarButtonItem *systemActionButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showActionSheet:)];
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    
    [self setToolbarItems:@[getLocationButton, flexibleSpaceButton, takePhotoButton, flexibleSpaceButton, takeNoteButton, flexibleSpaceButton, setParkTimeButton, flexibleSpaceButton,systemActionButton] animated:YES];
}


#pragma mark - Actions

- (IBAction)showActionSheet:(id)sender {
    UIActionSheet *shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:[[NSString alloc] initWithFormat:NSLocalizedString(@"CANCEL", @"The cancel button for the action sheet.")] destructiveButtonTitle:nil otherButtonTitles:[[NSString alloc] initWithFormat:NSLocalizedString(@"EMAIL", @"Email button in the action sheet.")], nil];
    [shareSheet showFromBarButtonItem:sender animated:YES];
}

- (IBAction)getLocation:(id)sender {
    [self.locationManager startLocationUpdate];
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
                            self.vehicle.placemark.thoroughfare,
                            self.vehicle.placemark.subThoroughfare,
                            self.vehicle.placemark.postalCode,
                            self.vehicle.placemark.locality,
                            self.vehicle.placemark.administrativeArea];
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


#pragma mark - TSSHLocationManagerDelegate

/*! Inform the delegate that the location process has finished.
 *
 * Called for the delegate.
 * \param success A BOOL that determines whether the location update was successful.
 */
- (void)didUpdateLocation:(BOOL)success withStatus:(TSSHLocationUpdateReturnStatus)status
{
    if (success) {
        self.vehicle.location = [self.locationManager.lastLocation copy];
        [self updateUI];
        [self saveVehicleStatus];
    } else {
        self.locationLabel.text = @"Could not get update.";
    }
}

- (void)didUpdateGeocode:(BOOL)success
{
    if (success) {
        self.vehicle.placemark = [self.locationManager.lastPlacemark copy];
        [self updateUI];
        [self saveVehicleStatus];
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
    MKCircleRenderer *circleRenderer = [[MKCircleRenderer alloc] initWithCircle:[MKCircle circleWithCenterCoordinate:self.vehicle.coordinate radius:self.vehicle.location.horizontalAccuracy]];
    circleRenderer.fillColor = [[UIColor blueColor] colorWithAlphaComponent:.2];
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


#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0:
            [self shareLocation:nil];
            break;
        case 1:
            break;
    }
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


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self saveVehicleStatus];
    return [textField resignFirstResponder];
}

@end
