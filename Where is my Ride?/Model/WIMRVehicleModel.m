//
//  WIMRVehicle.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleModel.h"

@interface WIMRVehicleModel ()


@end


@implementation WIMRVehicleModel

@dynamic coordinate;

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

//- (void)shareAnnotation
//{
//    NSLog(@"I am here: latitude %+.6f\nlongitude %+.6f", self.coordinate.latitude, self.coordinate.longitude);
//}

@end
