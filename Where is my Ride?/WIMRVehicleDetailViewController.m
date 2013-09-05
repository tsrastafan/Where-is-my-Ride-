//
//  WIMRViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleDetailViewController.h"
#import "WIMRVehicleModel.h"
#import "WIMRAppDelegate.h"



#pragma mark - Interface
@interface WIMRVehicleDetailViewController ()

#pragma mark Model
@property (strong, nonatomic) WIMRVehicleModel *vehicle;
@property (strong, nonatomic) TSSHLocationManager *locationManager;
@property (strong, nonatomic) NSManagedObjectContext *context;

#pragma mark - Controller
@property (strong, nonatomic) UIImagePickerController* imagePickerController;
//@property (strong, nonatomic) WIMRPhotoViewController *photoViewController;

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;

#pragma mark - ActionSheets
@property (strong, nonatomic) UIActionSheet *shareActionSheet;
@property (strong, nonatomic) UIActionSheet *parkingMeterActionSheet;

#pragma mark - Button Titles
@property (strong, readonly, nonatomic) NSString *cancelButtonTitle;
@property (strong, nonatomic) NSString *emailButtonTitle;
@property (strong, nonatomic) NSString *parkingAlertButtonTitle;
@property (strong, nonatomic) NSString *parkingTimerButtonTitle;
@property (strong, nonatomic) NSString *parkingStopWatchButtonTitle;

@end


#pragma mark - Implementation
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
    
    WIMRAppDelegate *appDelegate = (WIMRAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.mapView = appDelegate.mapView;
    
    MKMapView *mapView = self.mapView;

    [self.view addSubview:mapView];
    NSArray *horizontalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"|-[mapView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mapView)];
    NSArray *verticalContraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-[mapView]-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(mapView)];
    [self.view addConstraints:horizontalContraints];
    [self.view addConstraints:verticalContraints];
    
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.view attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0]];
//    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:self.mapView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:self.mapView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0]];
    
    
    self.vehicle.location = [NSKeyedUnarchiver unarchiveObjectWithData:self.managedObject.location];
    self.vehicle.placemark = [NSKeyedUnarchiver unarchiveObjectWithData:self.managedObject.placemark];
    self.vehicle.title = self.managedObject.title;
    self.vehicle.capturedImages = [NSKeyedUnarchiver unarchiveObjectWithData:self.managedObject.photos];
    if (!self.vehicle.capturedImages) self.vehicle.capturedImages = [[NSMutableArray alloc] init];
    
//    self.photoViewController = (WIMRPhotoViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    
    // set delegates
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    self.textField.delegate = self;
    self.typeTextField.delegate = self;
    
    [self createToolbarButtons];
    [self initializeActionSheetButtonTitles];
    
    [self updateUI];
    
    NSLog(@"%@", [self.mapView description]);
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showPhotos"])
    {
        [segue.destinationViewController setManagedObject:self.managedObject];
        [segue.destinationViewController setVehicle:self.vehicle];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Actions

- (IBAction)getLocation:(id)sender {
    [self.locationManager startLocationUpdate:sender];
    self.locationLabel.text = @"Updating ...";
    self.addressLabel.text = @"Updating ...";
    [self dimmBarButtonItem:sender];
}

- (IBAction)attachPhoto:(id)sender
{
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        return;
    }
    NSLog(@"Camera is here!");
    
    UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    //imagePickerController.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeMovie, nil];
    //imagePickerController.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
    //imagePickerController.allowsEditing = YES;
    self.imagePickerController = imagePickerController;
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (IBAction)showActionSheet:(id)sender {
    if ([[sender title] isEqualToString:@"parkingMeterButton"]) {
        [self.parkingMeterActionSheet showFromBarButtonItem:sender animated:YES];
    }
    if ([[sender title] isEqualToString:@"shareActionButton"]) {
        [self.shareActionSheet showFromBarButtonItem:sender animated:YES];
    }
}

/*! Shares the Location.
 *
 *  The location is shared, at the moment only via email.
 */
- (IBAction)shareLocation:(id)sender {
    // Email Subject
    NSString *emailTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"EMAIL_SUBJECT", @"E-Mail subject: Where is my ride?")];
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


#pragma mark - Action Sheets

- (void) initializeActionSheetButtonTitles
{
    
    //properties should accessed via setter.
    _cancelButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"CANCEL", @"Action sheet button: cancel action.")];
    _emailButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"EMAIL", @"Action sheet button: compose E-Mail")];
    _parkingAlertButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"PARKINGALERT", @"Action sheet button: Set date and time at which a vehicle has to removed from its parking spot.")];
    _parkingTimerButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"PARKINGTIMER", @"Action sheet button: Set maximum parking duration.")];
    _parkingStopWatchButtonTitle = [[NSString alloc] initWithFormat:NSLocalizedString(@"PARKINGSTOPWATCH", @"Action sheet button: Start a stop watch.")];
}

- (UIActionSheet *)shareActionSheet
{
    if (!_shareActionSheet) {
        _shareActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                        delegate:self
                                               cancelButtonTitle:self.cancelButtonTitle
                                          destructiveButtonTitle:nil
                                               otherButtonTitles:self.emailButtonTitle, nil];
    }
    return _shareActionSheet;
}

- (UIActionSheet *)parkingMeterActionSheet
{
    if (!_parkingMeterActionSheet) {
        _parkingMeterActionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                               delegate:self
                                                      cancelButtonTitle:self.cancelButtonTitle
                                                 destructiveButtonTitle:nil
                                                      otherButtonTitles:self.parkingAlertButtonTitle, self.parkingTimerButtonTitle, self.parkingStopWatchButtonTitle, nil];
    }
    return _parkingMeterActionSheet;
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
    self.managedObject.photos = [NSKeyedArchiver archivedDataWithRootObject:self.vehicle.capturedImages];
    
    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Error");
    }
    
    return !error;
}

- (void)createToolbarButtons
{
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    // getLocationButton
    UIImage *getLocationButtonImage = [UIImage imageNamed:@"location"];
    UIBarButtonItem *getLocationButton = [[UIBarButtonItem alloc] initWithImage:getLocationButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(getLocation:)];
    getLocationButton.title = @"getLocationButton";
    
    // attachPhotoButton
    UIImage *attachPhotoButtonImage = [UIImage imageNamed:@"photo"];
    UIBarButtonItem *attachPhotoButton = [[UIBarButtonItem alloc] initWithImage:attachPhotoButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(attachPhoto:)];
    attachPhotoButton.title = @"attachPhotoButton";
    
    // attachNoteButton
    UIImage *attachNoteButtonImage = [UIImage imageNamed:@"edit"];
    UIBarButtonItem *attachNoteButton = [[UIBarButtonItem alloc] initWithImage:attachNoteButtonImage style:UIBarButtonItemStylePlain target:self action:nil];
    attachNoteButton.title = @"attachNoteButton";
    attachNoteButton.tintColor = [UIColor lightGrayColor];
    
    // parkingMeterButton
    UIImage *parkingMeterButtonImage = [UIImage imageNamed:@"stopwatch"];
    UIBarButtonItem *parkingMeterButton = [[UIBarButtonItem alloc] initWithImage:parkingMeterButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    parkingMeterButton.title = @"parkingMeterButton";
    
    // shareActionButton
    UIImage *shareActionButtonImage = [UIImage imageNamed:@"upload"];
    UIBarButtonItem *shareActionButton = [[UIBarButtonItem alloc] initWithImage:shareActionButtonImage style:UIBarButtonItemStylePlain target:self action:@selector(showActionSheet:)];
    shareActionButton.title = @"shareActionButton";
    
    //flexibleSpaceButton
    UIBarButtonItem *flexibleSpaceButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    [self setToolbarItems:@[getLocationButton, flexibleSpaceButton, attachPhotoButton, flexibleSpaceButton, attachNoteButton, flexibleSpaceButton, parkingMeterButton, flexibleSpaceButton, shareActionButton] animated:YES];
}

- (void)dimmBarButtonItem: (UIBarButtonItem *)barButtonItem
{
//    barButtonItem.tintColor = [UIColor colorWithRed:0.556862745 green:0.556862745 blue:0.576470588 alpha:1]; // system gray
    barButtonItem.tintColor = [UIColor lightGrayColor];
}

- (void)restoreBarButtonItem: (UIBarButtonItem *)barButtonItem
{
    barButtonItem.tintColor = [UIColor colorWithRed:0 green:0.478431373 blue:1 alpha:1]; // system blue
}


#pragma mark - Delegate Implementations
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

- (void)didUpdateGeocode:(BOOL)success sender:(id)sender
{
    if (success) {
        self.vehicle.placemark = [self.locationManager.lastPlacemark copy];
        [self updateUI];
        [self saveVehicleStatus];
    } else {
        self.addressLabel.text = @"Could not get corresponding address.";
    }
    [self restoreBarButtonItem:sender];
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
        
        if (!thePinAnnotationView) {
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

    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    
    if ([buttonTitle isEqualToString:self.cancelButtonTitle]) {
        ;;  // do nothing
    }
    else if ([buttonTitle isEqualToString:self.emailButtonTitle]) {
        [self shareLocation:nil];
    }
    else if ([buttonTitle isEqualToString:self.parkingAlertButtonTitle]) {
        NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    else if ([buttonTitle isEqualToString:self.parkingTimerButtonTitle]) {
        NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    else if ([buttonTitle isEqualToString:self.parkingStopWatchButtonTitle]) {
        NSLog(@"%@",[actionSheet buttonTitleAtIndex:buttonIndex]);
    }
    else {
        ;;  //do nothing
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

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.vehicle.capturedImages addObject:image];
    [self saveVehicleStatus];
    [self dismissViewControllerAnimated:YES completion:NULL];
    self.imagePickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

@end
