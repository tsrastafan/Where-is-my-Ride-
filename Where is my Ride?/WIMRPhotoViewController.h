//
//  WIMRPhotoViewController.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 30.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WIMRVehicleModel.h"
#import "WIMRVehicleDataModel.h"

@interface WIMRPhotoViewController : UIViewController

@property (nonatomic, strong) WIMRVehicleModel *vehicle;
@property (nonatomic, strong) WIMRVehicleDataModel *managedObject;

@end
