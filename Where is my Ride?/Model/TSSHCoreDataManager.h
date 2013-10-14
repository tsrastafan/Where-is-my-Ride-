//
//  TSSHCoreDataManager.h
//  Where is my Ride?
//
//  Created by Tobias Schultz on 14/10/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TSSCoreDataManagerDelegate <NSObject>

@optional

- (NSFetchedResultsController *)fetchedResultsController;

@end

@interface TSSHCoreDataManager : NSObject

- (void)configureFetchedResultsControllerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext forEntity:(NSString *)entity withSortDescriptors:(NSArray *)sortDescriptors;


@end
