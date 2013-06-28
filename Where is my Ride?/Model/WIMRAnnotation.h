//
//  WIMRAnnotation.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/28/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WIMRAnnotation : NSObject <MKAnnotation>

@property (nonatomic) CLLocationCoordinate2D coordinate;

@end
