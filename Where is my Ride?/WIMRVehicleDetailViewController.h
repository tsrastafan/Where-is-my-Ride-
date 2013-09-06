//
//  WIMRVehicleDetailViewController.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 06.09.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIMRVehicleDataModel;

@interface WIMRVehicleDetailViewController : UIViewController <UITextFieldDelegate>

@property (strong, nonatomic) WIMRVehicleDataModel *vehicle;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
