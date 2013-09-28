//
//  WIMRVehicleDataModel.m
//  Where is my Ride?
//
//  Created by Steffen Heberle on 30.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleDataModel.h"


@implementation WIMRVehicleDataModel

@dynamic title;
@dynamic subtitle;
@dynamic coordinate;

@dynamic locationEncoded;
@dynamic placemarkEncoded;
@dynamic photosEncoded;

- (NSString *)subtitle
{
    if (!self.placemarkEncoded) {
        return nil;
    }
    else {
        CLPlacemark *placemark = self.placemark;
        return [[NSString alloc] initWithFormat:(@"%@ %@, %@ %@, %@"),
                placemark.thoroughfare,
                placemark.subThoroughfare,
                placemark.postalCode,
                placemark.locality,
                placemark.administrativeArea];
    }
}

- (CLLocationCoordinate2D)coordinate
{
    return self.location.coordinate;
}


- (CLLocation *)location
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.locationEncoded];
}

- (void)setLocation:(CLLocation *)location
{
    self.locationEncoded = [NSKeyedArchiver archivedDataWithRootObject:location];
}

- (CLPlacemark *)placemark
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.placemarkEncoded];
}

- (void)setPlacemark:(CLPlacemark *)placemark
{
    self.placemarkEncoded = [NSKeyedArchiver archivedDataWithRootObject:placemark];
}

- (NSMutableArray *)photos
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.photosEncoded];
}

- (void)setPhotos:(NSMutableArray *)photos
{
    self.photosEncoded = [NSKeyedArchiver archivedDataWithRootObject:photos];
}

//- (void)shareAnnotation
//{
//    NSLog(@"I am here: latitude %+.6f\nlongitude %+.6f", self.coordinate.latitude, self.coordinate.longitude);
//}


@end
