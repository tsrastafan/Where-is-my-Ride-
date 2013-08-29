//
//  TSSHPlacemark.m
//  Where is my Ride?
//
//  Created by Steffen Heberle on 29.08.13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "TSSHPlacemark.h"

@interface TSSHPlacemark ()


@end

@implementation TSSHPlacemark

- (TSSHPlacemark *)initWithPlacemark:(CLPlacemark *)placemark
{
    self = [super init];
    if (self) {
        self.addressDictionary = [[NSDictionary alloc] initWithDictionary:placemark.addressDictionary];
        self.administrativeArea = [[NSString alloc] initWithString:placemark.administrativeArea];
        self.areasOfInterest = [[NSArray alloc] initWithArray:placemark.areasOfInterest];
        self.country = [[NSString alloc] initWithString:placemark.country];
        self.inlandWater = [[NSString alloc] initWithString:placemark.inlandWater];
        self.ISOcountryCode = [[NSString alloc] initWithString:placemark.ISOcountryCode];
        self.locality = [[NSString alloc] initWithString:placemark.locality];
        self.name = [[NSString alloc] initWithString:placemark.name];
        self.ocean = [[NSString alloc] initWithString:placemark.ocean];
        self.postalCode = [[NSString alloc] initWithString:placemark.postalCode];
        self.subAdministrativeArea = [[NSString alloc] initWithString:placemark.subAdministrativeArea];
        self.subLocality = [[NSString alloc] initWithString:placemark.subLocality];
        self.subThoroughfare = [[NSString alloc] initWithString:placemark.subThoroughfare];
        self.thoroughfare = [[NSString alloc] initWithString:placemark.thoroughfare];
    }
    return self;
}

/*

- (TSSHPlacemark*) initWithAddressDictionary:(NSDictionary*) addressDictionary
                          administrativeArea:(NSString*) administrativeArea
                             areasOfInterest:(NSString*) areasOfInterest
                                     country:(NSString*) country
                                 inlandWater:(NSString*) inlandWater
                              ISOcountryCode:(NSString*) ISOcountryCode
                                    location:(CLLocation*)location
                                        name:(NSString*) name
                                       ocean:(NSString*) ocean
                                  postalCode:(NSString*) postalCode
                                      region:(CLRegion*) region
                       subAdministrativeArea:(NSString*) subAdministrativeArea
                                 subLocality:(NSString*) subLocality
                             subThoroughfare:(NSString*) subThoroughfare
                                thoroughfare:(NSString*) thoroughfare
{
    self = [super init];
    if (self) {
        //do nothing
    }
    
    return self;
}
 
 */

@end
