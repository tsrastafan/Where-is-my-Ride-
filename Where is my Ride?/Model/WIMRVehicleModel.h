//
//  WIMRVehicle.h
//  Where is my Ride iOS6
//
//  Created by Steffen on 17.06.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

typedef enum {
    CAR = 0,
    BICYCLE = 1
    
} VehicleType;

@interface WIMRVehicleModel : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) CLPlacemark *placemark;
@property (nonatomic, copy) NSString *name;
@property (nonatomic) VehicleType type;

- (void)shareAnnotation;

@end
