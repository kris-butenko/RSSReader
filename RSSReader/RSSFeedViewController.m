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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.rssEntries = [[NSMutableArray alloc] init];

    // Each tag attached to the details is included in the array
    NSArray *feeds = self.rssItem.feeds;
    
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
    return [self.rssEntries count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedItem *entry = [self.rssEntries objectAtIndex:indexPath.row];
    
    return [RSSFeedCell getCellHeight:entry];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"RSSFeedItemCell";
    
    RSSFeedCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[RSSFeedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    FeedItem *entry = [self.rssEntries objectAtIndex:indexPath.row];
    
    cell.rssTitleLabel.text = entry.title;
    cell.rssTextLabel.text = entry.content;
    
    return cell;
}

@end
