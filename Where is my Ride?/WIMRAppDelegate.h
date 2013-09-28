//
//  WIMRAppDelegate.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 6/17/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKMapView;

@interface WIMRAppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (readonly, nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) MKMapView *mapView;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
