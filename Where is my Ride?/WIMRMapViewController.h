//
//  WIMRViewController.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "TSSHLocationManager.h"

@class WIMRVehicle;

@interface WIMRMapViewController : UIViewController <TSSHLocationManagerDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

//@property (nonatomic) NSMutableArray *vehiclesArray;
//@property (nonatomic) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSIndexPath* selectedVehicleIndexPath;

- (void)performFetch;

@end
