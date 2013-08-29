//
//  WIMRLocationManager.h
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum {
    DESIRED_ACCURACY = 0,
    SOFT_TIME_LIMIT_EXCEEDED = 1,
    HARD_TIME_LIMIT_EXCEEDED = 2
} TSSHLocationUpdateReturnStatus;


@protocol TSSHLocationManagerDelegate <NSObject>

@required
- (void)didUpdateLocation:(BOOL)success withStatus:(TSSHLocationUpdateReturnStatus)status;
- (void)didUpdateGeocode:(BOOL)success;
@end


@interface TSSHLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong) id <TSSHLocationManagerDelegate> delegate;
@property (strong, nonatomic, readonly) CLLocation *lastLocation;
@property (strong, nonatomic, readonly) CLPlacemark *placemark;

- (void)startLocationUpdate;
- (void)stopLocationUpdate;

//- (void)setLastLocationLatitude:(NSNumber *)latitude longitude:(NSNumber *)longitude altitude:(NSNumber *)altitude horizontalAccuracy:(NSNumber *)hAccuracy verticalAccuracy:(NSNumber *)vAccuracy course:(NSNumber *)course speed:(NSNumber *)speed timestamp:(NSDate *)timestamp;

@end
