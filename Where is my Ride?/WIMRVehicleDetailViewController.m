//
//  WIMRVehicleDetailViewController.m
//  Where is my Ride?
//
//  Created by Steffen Heberle on 06.09.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleDetailViewController.h"
#import "WIMRVehicleModel.h"
#import "WIMRVehicleDataModel.h"

@interface WIMRVehicleDetailViewController ()

@property (strong, nonatomic) NSManagedObjectContext *context;

#pragma mark - Outlets
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *typeTextField;

@end

@implementation WIMRVehicleDetailViewController

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
    
    // set delegates
    self.textField.delegate = self;
    self.typeTextField.delegate = self;
    
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
}

- (BOOL)saveVehicleStatus
{
    self.managedObject.title = self.textField.text;
    self.managedObject.type = (NSDecimalNumber *)[NSDecimalNumber numberWithInt:[self.typeTextField.text intValue]];

    NSError *error = nil;
    if (![self.context save:&error]) {
        NSLog(@"Error");
    }
    
    return !error;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
//    [self saveVehicleStatus];
    return [textField resignFirstResponder];
}


@end
