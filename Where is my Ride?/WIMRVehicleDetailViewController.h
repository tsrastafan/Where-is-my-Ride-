//
//  WIMRViewController.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

// github test line

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MessageUI/MessageUI.h>
#import "TSSHLocationManager.h"
#import "WIMRVehicleDataModel.h"

@interface WIMRVehicleDetailViewController : UIViewController <TSSHLocationManagerDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) WIMRVehicleDataModel *managedObject;




@end
