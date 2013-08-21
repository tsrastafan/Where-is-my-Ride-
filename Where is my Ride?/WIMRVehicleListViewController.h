//
//  WIMRDeviceListViewController.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 8/20/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WIMRVehicleDetailViewController;
#import "WIMRVehicleDetailViewController.h"

@interface WIMRVehicleListViewController : UITableViewController <NSFetchedResultsControllerDelegate>


@property (strong, nonatomic) WIMRVehicleDetailViewController *vehicleDetailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
