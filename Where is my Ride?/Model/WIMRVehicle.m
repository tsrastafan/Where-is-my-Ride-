//
//  WIMRVehicle.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicle.h"

@interface WIMRVehicle ()


@end


@implementation WIMRVehicle

@dynamic subtitle;
@dynamic coordinate;

- (NSString *)subtitle
{
    if (!self.placemark) {
        return nil;
    }
    else {
        return [[NSString alloc] initWithFormat:(@"%@ %@, %@ %@, %@"),
                self.placemark.thoroughfare,
                self.placemark.subThoroughfare,
                self.placemark.postalCode,
                self.placemark.locality,
                self.placemark.administrativeArea];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}

//- (void)shareAnnotation
//{
//    NSLog(@"I am here: latitude %+.6f\nlongitude %+.6f", self.coordinate.latitude, self.coordinate.longitude);
//}

@end
