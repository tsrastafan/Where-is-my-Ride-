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
#import "WIMRLocationModel.h"
#import "WIMRVehicleDataModel.h"

@interface WIMRVehicleDetailViewController : UIViewController <WIMRLocationModelDelegate, MKMapViewDelegate, MFMailComposeViewControllerDelegate, UITextFieldDelegate>

@property (nonatomic, strong) WIMRVehicleDataModel *managedObject;
@property (nonatomic, strong) NSManagedObjectContext *context;
//@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;



@end
