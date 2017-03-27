//
//  RSSFeedViewController.m
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "RSSFeedViewController.h"
#import "RSSFeedCell.h"
#import "FeedDetailViewController.h"

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
    if ([[self fetchedResultsController] performFetch:&error])
    {
        [self.rssEntries addObjectsFromArray: [self fetchedResultsController].fetchedObjects];
        [self.tableView reloadData];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

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
    //FeedItem *entry = (FeedItem *)[self.fetchedResultsController objectAtIndexPath:indexPath];

    return 87;// [RSSFeedCell getCellHeight:entry];
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
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEE, dd MMM yyyy"];
    cell.rssTextLabel.text = [dateFormatter stringFromDate: entry.published];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FeedItem *entry = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
    FeedDetailViewController *detailViewController = [storyboard instantiateViewControllerWithIdentifier:@"FeedDetailViewController"];
    
    detailViewController.articleString = entry.content;
    
    [self.navigationController pushViewController:detailViewController animated:YES];
}


#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"FeedItem" inManagedObjectContext:self.rssItem.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"published" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    [fetchRequest setFetchBatchSize:20];
    
    NSManagedObjectID *moID = [self.rssItem objectID];
    NSString *uniqueStringKey = [moID.URIRepresentation.absoluteString lastPathComponent];
    NSString *predicateString = [[NSString alloc] initWithFormat:@"(rssID = \"%@\")", uniqueStringKey];
    
    NSPredicate *requestPredicate = [NSPredicate predicateWithFormat:predicateString];
    [fetchRequest setPredicate:requestPredicate];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:self.rssItem.managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:nil];
    _fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
}

@end
