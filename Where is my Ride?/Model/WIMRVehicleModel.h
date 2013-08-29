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

#pragma mark - Properties used by MKAnnotation protocol
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *subtitle;
@property (nonatomic) CLLocationCoordinate2D coordinate;

#pragma mark - Other properties
@property (nonatomic) VehicleType type;
@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, strong) CLPlacemark *placemark;

#pragma mark - Methods used by MKAnnotation protocol
/* The following method should be implemented when Annotation supports dragging.
 * If implemented, the update of the value of the coordinate has to be
 * key-value observing (KVO) compliant.
 *
 * Also see xcdoc://ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html
 */
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate

#pragma mark - Other methods
//- (void)shareAnnotation;

@end
