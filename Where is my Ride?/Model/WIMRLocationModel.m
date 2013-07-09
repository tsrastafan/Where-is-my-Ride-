//
//  WIMRLocationManager.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#define TIME_INTERVAL_BETWEEN_GPS_FIXES 5
#define TIME_FOR_PROBING_FOR_BEST_ACCURACY 5

#import "WIMRLocationModel.h"

@interface WIMRLocationModel ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (nonatomic) BOOL performingReverseGeocoding;
@property (strong, nonatomic) CLLocation *firstLocationResult;

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
- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (!self.locationManager) {
        self.locationManager = [[CLLocationManager alloc] init];
    }
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events. Do we need this at all?
    // self.locationManager.distanceFilter = 5;
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopStandardUpdates
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
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If it's a relatively recent event, turn off updates to save power
        [manager stopUpdatingLocation];
        self.lastLocation = location;
        [self geocodeLocation:location];
        [self.delegate locationUpdateSuccessful:YES];
    }
}


- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}


@end
