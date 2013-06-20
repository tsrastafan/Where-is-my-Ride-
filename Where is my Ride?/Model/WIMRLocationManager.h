//
//  WIMRLocationManager.h
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@protocol UpdateLocationDelegate <NSObject>
@required
-(void) locationUpdateSuccessful: (BOOL)success;
@end


@interface WIMRLocationManager : NSObject <CLLocationManagerDelegate> {
    id <UpdateLocationDelegate> delegate;
}

@property (retain) id delegate;
@property (strong, nonatomic) CLLocation * lastLocation;
@property (strong, nonatomic) CLPlacemark * placemark;

- (void)startStandardUpdates;
- (void)stopStandardUpdates;
- (void)geocodeLocation:(CLLocation*)location;

@end
