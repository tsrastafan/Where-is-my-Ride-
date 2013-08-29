//
//  WIMRVehicleDataModel.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 29.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface WIMRVehicleDataModel : NSManagedObject

@property (nonatomic, retain) NSData * location;
@property (nonatomic, retain) NSData * placemark;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSDecimalNumber * type;

@end
