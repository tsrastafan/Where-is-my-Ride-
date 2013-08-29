//
//  WIMRLocationManager.m
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#define TIME_INTERVAL_BETWEEN_GPS_FIXES 5
#define TIME_FOR_PROBING_FOR_BEST_ACCURACY 5

#import "TSSHLocationManager.h"

@interface TSSHLocationManager ()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLGeocoder *geocoder;
@property (strong, nonatomic) NSTimer *softTimer;
@property (strong, nonatomic) NSTimer *hardTimer;

@property (nonatomic, strong, readwrite) CLLocation *lastLocation;
@property (nonatomic, strong, readwrite) CLPlacemark *placemark;

@property (nonatomic) CLLocationAccuracy desiredAccuracy;
@property (nonatomic) NSUInteger softTimeLimitForLocationFix;
@property (nonatomic) NSUInteger hardTimeLimitForLocationFix;

@property (nonatomic) BOOL softTimeLimitForLocationFixExceeded;
@property (nonatomic) BOOL hardTimeLimitForLocationFixExceeded;
@property (nonatomic) BOOL performingReverseGeocoding;

@end


@implementation TSSHLocationManager {
    
}

/*! Designated initializer
 *
 */
- (TSSHLocationManager *)init
{
    if (self = [super init]) {
        self.desiredAccuracy = 5;
        self.softTimeLimitForLocationFix = 3;
        self.hardTimeLimitForLocationFix = 20;
        self.performingReverseGeocoding = NO;
    }
    return self;
}



///*! Set the CLLocation object (from CoreData)
// *
// * Blaa blaaaa
// */
//- (void)setLastLocationLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude altitude:(NSNumber *)altitude horizontalAccuracy:(NSNumber *)hAccuracy verticalAccuracy:(NSNumber *)vAccuracy course:(NSNumber *)course speed:(NSNumber *)speed timestamp:(NSDate *)timestamp
//{
//    self.lastLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]) altitude:[altitude doubleValue] horizontalAccuracy:[hAccuracy doubleValue] verticalAccuracy:[vAccuracy doubleValue] course:[course doubleValue] speed:[speed doubleValue] timestamp:timestamp];
//}


/*! Set a time limit for fixing the location.
 *
 * \params timeStatus Status code for the exceeded time limit.
 * 1 means soft time limit exceeded, 2 means hard time limit exceeded.
 */
- (void)setSoftTimeLimitForLocationFixExceededYES:(NSTimer *)timer {
    self.softTimeLimitForLocationFixExceeded = YES;
}

- (void)setHardTimeLimitForLocationFixExceededYES:(NSTimer *)timer {
    self.hardTimeLimitForLocationFixExceeded = YES;
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
    
    self.softTimeLimitForLocationFixExceeded = NO;
    self.hardTimeLimitForLocationFixExceeded = NO;

    self.softTimer = [NSTimer scheduledTimerWithTimeInterval:self.softTimeLimitForLocationFix target:self selector:@selector(setSoftTimeLimitForLocationFixExceededYES:) userInfo:nil repeats:NO];
    self.hardTimer = [NSTimer scheduledTimerWithTimeInterval:self.hardTimeLimitForLocationFix target:self selector:@selector(setHardTimeLimitForLocationFixExceededYES:) userInfo:nil repeats:NO];
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
             [self.delegate didUpdateGeocode:YES];
         }];
    }
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    
    self.lastLocation = location;
    
//    if (location.horizontalAccuracy < self.lastLocation.horizontalAccuracy) { //danger -> last location not set
//       // self.lastLocation = location;
//    }
    
    if (location.horizontalAccuracy <= self.desiredAccuracy) {
        [self.locationManager stopUpdatingLocation];
        [self.delegate didUpdateLocation:YES withStatus:DESIRED_ACCURACY];
        [self geocodeLocation:location];
    } else {
        if (self.softTimeLimitForLocationFixExceeded) {
            if (self.hardTimeLimitForLocationFixExceeded) {
                [self.locationManager stopUpdatingLocation];
                [self.delegate didUpdateLocation:YES withStatus:HARD_TIME_LIMIT_EXCEEDED];
                [self geocodeLocation:location];
            } else {
                [self.delegate didUpdateLocation:YES withStatus:SOFT_TIME_LIMIT_EXCEEDED];
                //[self geocodeLocation:location];
            }
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError %@", error);
}


@end
