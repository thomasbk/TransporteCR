//
//  BusSelectionViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 24/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"
#import "Bus_Routes.h"
#import "BusRouteSelectionDelegate.h"



@interface BusRouteSelectionViewController : AresepViewController <NSFetchedResultsControllerDelegate,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic) BOOL searchIsActive;

@property (strong, nonatomic) UISearchController *searchController;

@property (nonatomic, weak)id <BusRouteSelectionDelegate> delegate;

@end
