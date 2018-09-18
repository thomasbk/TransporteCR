//
//  TrainRouteSelectionViewController.h
//  aresep
//
//  Created by Jorge Mendoza Martínez on 25/09/13.
//  Copyright (c) 2013 SOIN. All rights reserved.
//

#import "AresepViewController.h"
#import "TrainRouteSelectionDelegate.h"
#import "Train_Routes.h"


@interface TrainRouteSelectionViewController : AresepViewController<NSFetchedResultsControllerDelegate,UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic) BOOL searchIsActive;

@property (strong, nonatomic) UISearchController *searchController;

@property (nonatomic, weak)id <TrainRouteSelectionDelegate> delegate;


@end
