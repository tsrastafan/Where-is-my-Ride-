//
//  TSSHCoreDataManager.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 14/10/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "TSSHCoreDataManager.h"

@interface TSSHCoreDataManager ()

@property (nonatomic, strong) NSFetchedResultsController * fetchedResultsController;

@end

@implementation TSSHCoreDataManager

- (void)configureFetchedResultsControllerWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext forEntity:(NSString *)entity withSortDescriptors:(NSArray *)sortDescriptors
{
    if (_fetchedResultsController) {
        return;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entity inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entityDescription];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObjects:sortDescriptors, nil]];
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:managedObjectContext sectionNameKeyPath:nil cacheName:@"Root"];
}

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController) {
        return _fetchedResultsController;
    } else {
        return nil;
    }
}

@end
