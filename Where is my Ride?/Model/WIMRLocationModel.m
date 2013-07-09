//
//  WIMRLocationManager.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#define MINIMAL_ACCURACY 5

#define TIME_INTERVAL_BETWEEN_GPS_FIXES 5
#define TIME_FOR_PROBING_FOR_BEST_ACCURACY 5

#import "WIMRLocationModel.h"

@interface WIMRLocationModel ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic) BOOL performingReverseGeocoding;

@end


@implementation WIMRLocationModel

// designated initializer
- (WIMRLocationModel *)init
{
    if (self = [super init]) {
        self.performingReverseGeocoding = NO;
    }
    return self;
}

/*! Start a standard location update.
 *
 */
- (void)startLocationUpdate
{
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 5;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopLocationUpdate
{
    [self.locationManager stopUpdatingLocation];
}


- (void)geocodeLocation:(CLLocation *)location
{
    if (!self.geocoder) {
        self.geocoder = [[CLGeocoder alloc] init];
    }
    
    if (!self.performingReverseGeocoding) {
        self.performingReverseGeocoding = YES;
        [self.geocoder reverseGeocodeLocation:location completionHandler:
         ^(NSArray *placemarks, NSError *error) {
             if (error == nil && [placemarks count] > 0) {
                 self.placemark = [placemarks lastObject];
             } else {
                 self.placemark = nil;
             }
             self.performingReverseGeocoding = NO;
             [self.delegate reverseGeocodingCompleted:YES];
         }];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    if (location.horizontalAccuracy > 0) {
        self.lastLocation = location;
        if (location.horizontalAccuracy <= MINIMAL_ACCURACY) {
            [self.delegate didUpdateLocationWithDesiredAccuracy:YES];
            [self geocodeLocation:location];
        } else {
            [self.delegate didUpdateLocationWithDesiredAccuracy:NO];
        }
    }

}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}


@end
