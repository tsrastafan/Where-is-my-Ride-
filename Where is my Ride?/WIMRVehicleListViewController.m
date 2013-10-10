//
//  WIMRDeviceListViewController.m
//  Where is my Ride?
//
//  Created by Tobias Schultz on 8/20/13.
//  Copyright (c) 2013 Tobias Schultz and Steffen Heberle. All rights reserved.
//

#import "WIMRVehicleListViewController.h"
#import "WIMRVehicleDataModel.h"
#import "WIMRMapViewController.h"
#import "WIMRAppDelegate.h"
#import "SWRevealViewController.h"

@interface WIMRVehicleListViewController ()


@property (nonatomic, strong, readonly) NSManagedObjectContext *managedObjectContext;

@property (nonatomic) NSMutableArray *vehiclesArray;

@end

@implementation WIMRVehicleListViewController


- (NSManagedObjectContext *)managedObjectContext
{
    WIMRAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    return appDelegate.managedObjectContext;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.managedObjectContext = self.appDelegate.managedObjectContext;
    

        
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addVehicle:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    // set up a fetch request
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    request.entity = [NSEntityDescription entityForName:@"Vehicle" inManagedObjectContext:self.managedObjectContext];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"title" ascending:NO];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescriptor, nil];
    request.sortDescriptors = sortDescriptors;
    
    // execute fetch request
    NSError *error = nil;
    NSMutableArray *mutableFetchResults = [[self.managedObjectContext executeFetchRequest:request error:&error] mutableCopy];
    if (!mutableFetchResults) {
        // Handle the error.
    }
    self.vehiclesArray = mutableFetchResults;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:YES animated:YES];
    
    self.navigationController.view.frame = CGRectMake(0, 0, SW_REVEAL_VIEW_CONTROLLER_REAR_VIEW_WIDTH, self.view.frame.size.height);
//    UIBarButtonItem *toolbarButton = [[UIBarButtonItem alloc] initWithTitle:@"WAI" style:UIBarButtonItemStyleBordered target:self action:nil];
//    [self setToolbarItems:[[NSArray alloc] initWithObjects:toolbarButton, nil] animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addVehicle:(id)sender
{
    WIMRVehicleDataModel *newVehicle = [NSEntityDescription insertNewObjectForEntityForName:@"Vehicle" inManagedObjectContext:self.managedObjectContext];
    newVehicle.title = @"Mein Auto";
    
    //Save the context
    NSError *error;
    if (![self.managedObjectContext save:&error]) {
#warning Handle error, when saving context
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    // insert new event in eventArray and adjust tableView
    [self.vehiclesArray insertObject:newVehicle atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showMap"]) {
        WIMRMapViewController *mapViewController = segue.destinationViewController;
        mapViewController.vehiclesArray = self.vehiclesArray;
        mapViewController.selectedVehicleIndex = [self.tableView indexPathForSelectedRow].row;
        mapViewController.managedObjectContext = self.managedObjectContext;
    }
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
            
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController setViewControllers: @[dvc] animated: NO ];
            [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
        };
        
    }
}


# pragma mark - Table View Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.vehiclesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Dequeue or create a new cell.
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
//    WIMRVehicleDataModel *vehicle = [self.vehiclesArray objectAtIndex:(NSInteger)indexPath.row];
    
    cell.textLabel.text = ((WIMRVehicleDataModel*)self.vehiclesArray[indexPath.row]).title;
    cell.detailTextLabel.text = ((WIMRVehicleDataModel*)self.vehiclesArray[indexPath.row]).subtitle;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        // Delete managed object at specified index path
        [self.managedObjectContext deleteObject:[self.vehiclesArray objectAtIndex:indexPath.row]];
#warning For WIMRMapViewController: Remove AnnotationView from MapView before deleting object.
        
        // Update array and table view
        [self.vehiclesArray removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade]; // @[indexPath] == [NSArray arrayWithObject:indexPath]
        
        // Commit changes
        NSError *error;
        if (![self.managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // The table view should not be re-orderable.
    return NO;
}

@end
