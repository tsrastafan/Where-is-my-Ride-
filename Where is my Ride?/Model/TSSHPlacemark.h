//
//  TSSHPlacemark.h
//  Where is my Ride?
//
//  Created by Steffen Heberle on 29.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

@interface TSSHPlacemark : NSObject


@property(nonatomic) NSDictionary *addressDictionary;
@property(nonatomic) NSString *administrativeArea;
@property(nonatomic) NSArray *areasOfInterest;
@property(nonatomic) NSString *country;
@property(nonatomic) NSString *inlandWater;
@property(nonatomic) NSString *ISOcountryCode;
@property(nonatomic) NSString *locality;
@property(nonatomic) NSString *name;
@property(nonatomic) NSString *ocean;
@property(nonatomic) NSString *postalCode;
@property(nonatomic) NSString *subAdministrativeArea;
@property(nonatomic) NSString *subLocality;
@property(nonatomic) NSString *subThoroughfare;
@property(nonatomic) NSString *thoroughfare;


- (TSSHPlacemark*) initWithPlacemark:(CLPlacemark*) placemark;



@end
