//
//  WIMRDeviceListViewController.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 8/20/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WIMRVehicleListViewController : UITableViewController

@property (nonatomic) NSMutableArray *vehiclesArray;
@property (nonatomic) NSManagedObjectContext *managedObjectContext;

@end
