//
//  WIMRLocationManager.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRLocationModel.h"

@interface WIMRLocationModel ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;


@end


@implementation WIMRLocationModel

- (void)startStandardUpdates
{
    // Create the location manager if this object does not
    // already have one.
    if (!self.locationManager)
        self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // Set a movement threshold for new events.
    self.locationManager.distanceFilter = 5;
    
    [self.locationManager startUpdatingLocation];
}

- (void)stopStandardUpdates
{
    [self.locationManager stopUpdatingLocation];
}


- (void)geocodeLocation:(CLLocation *)location
{
    if (!self.geocoder)
        self.geocoder = [[CLGeocoder alloc] init];
    
    [self.geocoder reverseGeocodeLocation:location completionHandler:
     ^(NSArray *placemarks, NSError *error){
         if ([placemarks count] > 0)
         {
             self.placemark = [placemarks lastObject];
         }
     }];
    
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    CLLocation *location = [locations lastObject];
    NSDate *eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (abs(howRecent) < 15.0) {
        // If it's a relatively recent event, turn off updates to save power
        [manager stopUpdatingLocation];
        self.lastLocation = location;
        [self geocodeLocation:location];
        [[self delegate] locationUpdateSuccessful:YES];
    }
}
@end
