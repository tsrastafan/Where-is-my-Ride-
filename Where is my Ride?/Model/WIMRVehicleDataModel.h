//
//  WIMRVehicleDataModel.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 30.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MapKit/MapKit.h>

@interface WIMRVehicleDataModel : NSManagedObject <MKAnnotation>

#pragma mark - Properties used by MKAnnotation protocol
@property (nonatomic, copy) NSString *title;
@property (nonatomic, readonly) NSString *subtitle;
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;

#pragma mark - Properties of which values are in a persistent store
@property (nonatomic, retain) NSData *locationEncoded;
@property (nonatomic, retain) NSData *placemarkEncoded;
@property (nonatomic, retain) NSData *photosEncoded;

#pragma mark - Accessors
@property (nonatomic, weak) CLLocation *location;
@property (nonatomic, weak) CLPlacemark *placemark;
@property (nonatomic, weak) NSMutableArray *photos;

#pragma mark - Methods used by MKAnnotation protocol
/* The following method should be implemented when Annotation supports dragging.
 * If implemented, the update of the value of the coordinate has to be
 * key-value observing (KVO) compliant.
 *
 * Also see xcdoc://ios/documentation/Cocoa/Conceptual/KeyValueObserving/KeyValueObserving.html
 */
//- (void)setCoordinate:(CLLocationCoordinate2D)newCoordinate;

#pragma mark - Other methods
//- (void)shareAnnotation;

@end
