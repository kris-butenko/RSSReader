//
//  RSSFeedViewController.m
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "RSSFeedViewController.h"
#import "RSSFeedCell.h"

#import "FeedItem.h"
#import "RSSItem.h"

@interface RSSFeedViewController ()

@property (nonatomic, strong) NSMutableArray *rssEntries;
@property (nonatomic, strong) IBOutlet UITableView *tableView;

@end

@implementation RSSFeedViewController

@synthesize rssItem = _rssItem;
@synthesize fetchedResultsController = _fetchedResultsController;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rssEntries = [[NSMutableArray alloc] init];

    NSError *error;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    // Each tag attached to the details is included in the array
    NSSet *feeds = [self.rssItem valueForKey:@"feeds"] ;
    
    for (FeedItem *feed in feeds) {
        [self.rssEntries addObject:feed];
    }
    
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table view data source

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return [self.rssEntries count];
    
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
   // FeedItem *entry = [self.rssEntries objectAtIndex:indexPath.row];
    FeedItem *entry = (FeedItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    return [RSSFeedCell getCellHeight:entry];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RSSFeedItemCell";
    
    RSSFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RSSFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FeedItem *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    cell.rssTitleLabel.text = entry.title;
    cell.rssTextLabel.text = entry.content;
    
    return cell;
}

#pragma mark - Result controller

- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FeedItem"
                                   inManagedObjectContext:self.rssItem.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"published"
                                        ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *aFetchedResultsController = [[NSFetchedResultsController alloc]  initWithFetchRequest:fetchRequest
                                                                                                 managedObjectContext:self.rssItem.managedObjectContext
                                                                                                   sectionNameKeyPath:nil
                                                                                                            cacheName:nil];
    
    self.fetchedResultsController = aFetchedResultsController;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _fetchedResultsController;
}

@end
