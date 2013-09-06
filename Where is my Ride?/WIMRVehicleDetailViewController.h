//
//  WIMRVehicleDetailViewController.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 06.09.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WIMRVehicleDataModel;
@class WIMRVehicle;

@interface WIMRVehicleDetailViewController : UIViewController <UITextFieldDelegate>

@property (nonatomic, strong) WIMRVehicleDataModel *managedObject;
@property (strong, nonatomic) WIMRVehicle *vehicle;

@end
