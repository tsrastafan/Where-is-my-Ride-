//
//  WIMRVehicleDataModel.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 8/18/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIMRVehicleDataModel : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) id location;

@end
