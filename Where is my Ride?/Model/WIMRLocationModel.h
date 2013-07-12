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
} LocationUpdateReturnStatus;

@protocol WIMRLocationModelDelegate <NSObject>

// rename methods!
@required
- (void)didUpdateLocation:(BOOL)success withStatus:(LocationUpdateReturnStatus)status;
- (void)reverseGeocodingCompleted:(BOOL)completed;
@end


@interface WIMRLocationModel : NSObject <CLLocationManagerDelegate>


@property (strong) id <WIMRLocationModelDelegate> delegate;
@property (strong, nonatomic) CLLocation *lastLocation;
@property (strong, nonatomic) CLPlacemark *placemark;

- (void)startLocationUpdate;
- (void)stopLocationUpdate;

@end
