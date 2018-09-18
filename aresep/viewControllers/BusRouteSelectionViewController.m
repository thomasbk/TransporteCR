//
//  BusSelectionViewController.m
//  aresep
//
//  Created by Jorge Mendoza Martínez on 24/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "BusRouteSelectionViewController.h"
#import "Bus_Routes.h"
#import "IOSVersion.h"
#import "Fonts.h"
#import "NSString+Utils.h"

@interface BusRouteSelectionViewController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

- (void) back;

@end

@implementation BusRouteSelectionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self setTitle:@"Buses"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSError *error;
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
    self.searchController.delegate = self;
    [self.view addSubview:self.searchController.searchBar];
    self.searchController.searchBar.placeholder = @"Filtrar Rutas de Buses";
    self.definesPresentationContext = YES;
    
    
    self.tableView.frame = CGRectMake(0, self.searchController.searchBar.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.searchController.searchBar.frame.size.height);
    
    
    
    if (![[self fetchedResultsController] performFetch:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self addNavigationButtonLeft:@"Atrás" target:self action:@selector(back)];
    
    if ([IOSVersion isIOS7])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.tableView reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setFont:[Fonts regularFontWithSize:14]];
    
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) back
{
    [self popViewController];
}

#pragma mark -
#pragma mark Fetched results controller

/*
 Returns the fetched results controller. Creates and configures the controller if necessary.
 */
- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    // Create and configure a fetch request with the Book entity.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Bus_Routes" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSPredicate *predicateName = [NSPredicate predicateWithFormat:@"regularFare.length > 0"];
    [fetchRequest setPredicate:predicateName];
    
    // Create the sort descriptors array.
    NSSortDescriptor *sortDescription = [[NSSortDescriptor alloc] initWithKey:@"routeName" ascending:YES];
    NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:sortDescription, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    
    
    // Create and initialize the fetch results controller.
    _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                    managedObjectContext:self.managedObjectContext
                                                                      sectionNameKeyPath:nil
                                                                               cacheName:nil];
    
    _fetchedResultsController.delegate = self;
    
    // Memory management.
    
    return _fetchedResultsController;
}



#pragma mark -
#pragma mark Table view data source methods

/*
 The data source methods are handled primarily by the fetch results controller
 */

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:0];
    return [sectionInfo numberOfObjects];
    
}


// Customize the appearance of table view cells.

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    // Configure the cell to show the book's title
    Bus_Routes *route = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@", route.routeName];
    [cell.textLabel setFont:[Fonts regularFontWithSize:15]];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        // More initializations if needed.
    }
    
    // Configure the cell.
    [self configureCell:cell atIndexPath:indexPath];
    
    return cell;
}


//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    // Display the authors' names as section headings.
//    return [[[self.fetchedResultsController sections] objectAtIndex:section] name];
//}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bus_Routes *route = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [self.navigationController dismissViewControllerAnimated:YES completion:^
    {
       [self.delegate busRouteSelected:route];
    }];
}


#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"routeId.stringValue contains[c] %@ OR routeName contains[c] %@", searchText, searchText];
    [[self.fetchedResultsController fetchRequest] setPredicate:predicate];
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    [self.tableView reloadData];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    self.fetchedResultsController = nil;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self setSearchIsActive:NO];
    [self.tableView reloadData];
}


#pragma mark -
#pragma mark UISearchController Delegate Methods


- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    if([[searchController.searchBar text] length] > 0) {
        [self filterContentForSearchText:[searchController.searchBar text] scope:[searchController.searchBar selectedScopeButtonIndex]];
    }
    
}


- (void)willPresentSearchController:(UISearchController *)searchController {
    [self setSearchIsActive:YES];
    
    [UIView animateWithDuration:0.2f animations:^{
    self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y + 20, self.view.frame.size.width, self.view.frame.size.height - 20);
    }];
    return;
}

- (void)willDismissSearchController:(UISearchController *)searchController {
    
    [UIView animateWithDuration:0.3f animations:^{
        self.tableView.frame = CGRectMake(0, self.tableView.frame.origin.y - 20, self.view.frame.size.width, self.view.frame.size.height + 20);
    }];
}

- (void)didDismissSearchController:(UISearchController *)searchController {
    
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    self.fetchedResultsController = nil;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self setSearchIsActive:NO];
    [self.tableView reloadData];
    return;
}





#pragma mark -
#pragma mark UISearchDisplayController Delegate Methods

/*

- (BOOL)searchDisplayController:(UISearchController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:[controller.searchBar text] scope:[controller.searchBar selectedScopeButtonIndex]];
    
    return YES;
}




- (void)searchDisplayController:(UISearchController *)controller didHideSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    
}



- (void)searchDisplayController:(UISearchController *)controller willShowSearchResultsTableView:(UITableView *)tableView {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide) name:UIKeyboardWillHideNotification object:nil];
    
}



- (void) keyboardWillHide {
    
    UITableView *tableView = [[self searchDisplayController] searchResultsTableView];
    
    [tableView setContentInset:UIEdgeInsetsZero];
    
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
    
}

- (void)searchDisplayControllerWillBeginSearch:(UISearchController *)controller
{
    
    [self setSearchIsActive:YES];
    return;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchController *)controller
{
    [NSFetchedResultsController deleteCacheWithName:nil];
    
    self.fetchedResultsController = nil;
    
    NSError *error = nil;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Handle error
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    [self setSearchIsActive:NO];
    [self.tableView reloadData];
    return;
}
 

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    if ([self searchIsActive]) {
        [[[self searchDisplayController] searchResultsTableView] beginUpdates];
    }
    else  {
        [self.tableView beginUpdates];
    }
}
- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([self searchIsActive]) {
        [[[self searchDisplayController] searchResultsTableView] endUpdates];
    }
    else  {
        [self.tableView endUpdates];
    }
}
*/

@end
