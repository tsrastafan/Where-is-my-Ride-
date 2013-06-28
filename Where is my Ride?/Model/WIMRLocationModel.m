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
     didUpdateLocations:(NSArray *)locations {
    NSLog(@"***did update to location: %@", [locations lastObject]);
    CLLocation *newLocation = [locations lastObject];
    if (self.firstLocationResult == nil) {
        self.firstLocationResult = newLocation;
    }
    //NSDate *eventDate = newLocation.timestamp;
    //NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if ([newLocation.timestamp timeIntervalSinceNow] < -TIME_INTERVAL_BETWEEN_GPS_FIXES) {
        NSLog(@"***TIME INTERVAL EXIT");
        return;
    }
    if (newLocation.horizontalAccuracy < 0) {
        NSLog(@"***Accuracy Exit");
        return;
    }
    
    if (self.lastLocation == nil || self.lastLocation.horizontalAccuracy >= newLocation.horizontalAccuracy) {
        self.lastLocation = newLocation;
        if ([self.firstLocationResult.timestamp timeIntervalSinceNow] < -TIME_FOR_PROBING_FOR_BEST_ACCURACY) {
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
        }
        NSLog(@"******in last loop");
        if (newLocation.horizontalAccuracy <= self.locationManager.desiredAccuracy) {
            NSLog(@"***we're done!");
            self.firstLocationResult = nil;
            [self.locationManager stopUpdatingLocation];
            [self geocodeLocation:self.lastLocation];
            [self.delegate locationUpdateSuccessful:YES];
        }
    }
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}


@end
