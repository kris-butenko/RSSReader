//
//  RSSDataManager.m
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "RSSDataManager.h"
#import "RSSItem.h"
#import "FeedItem.h"

#import "GDataXMLNode.h"
#import "GDataXMLElement-Extras.h"


@implementation RSSDataManager

@synthesize managedObjectContext;
@synthesize fetchedResultsController = _fetchedResultsController;

+ (RSSDataManager*)shared
{
    static RSSDataManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (void) startRSS
{
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [self fillDB];
    }
    else
    {
        for (RSSItem* item in self.fetchedResultsController.fetchedObjects)
            [self updateRSS:item];
    }
}

- (void) fillDB {

    RSSItem *rssItem = [self saveNewRSSWithTitle: @"Apple News"
                                            link: @"http://images.apple.com/main/rss/hotnews/hotnews.rss"];
    
    RSSItem *rssItem2 = [self saveNewRSSWithTitle: @"Cocoa"
                                            link: @"http://cocoawithlove.com/feeds/posts/default"];
    
    RSSItem *rssItem3 = [self saveNewRSSWithTitle: @"World"
                                             link: @"http://rss.cnn.com/rss/edition_world.rss"];
    
    [self updateRSS:rssItem];
    [self updateRSS:rssItem2];
    [self updateRSS:rssItem3];
}

-(RSSItem*)saveNewRSSWithTitle:(NSString*)name link:(NSString*)link
{
    NSManagedObjectContext *context = [self managedObjectContext];
    RSSItem *rssItem = [NSEntityDescription
                        insertNewObjectForEntityForName:@"RSSItem"
                        inManagedObjectContext:context];
    rssItem.title = name;
    rssItem.link = link;
    rssItem.updateDate = [NSDate date];
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Whoops, couldn't save: %@", [error localizedDescription]);
    }
    
    [self updateRSS:rssItem];
    
    return rssItem;
}

-(void) updateRSS:(RSSItem*)rssItem
{
    
    NSURL *url = [NSURL URLWithString: rssItem.link];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    __weak typeof(self) weakSelf = self;
    
    NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response,
                            NSError * _Nullable error)
                                  {
                                      NSError *jsonParsingError = nil;
                                      GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithData: data options:0 error:&jsonParsingError];
                                      
                                      if (doc == nil) {
                                          NSLog(@"Failed to parse %@", request);
                                      } else {
                                          
                                          NSArray* itemsDict = [weakSelf parseRss:doc.rootElement];
  
                                          for (NSDictionary* dict in itemsDict)
                                              [weakSelf saveNewFeed:dict forRSSItem:rssItem];
                                      }
                                  }];

    [task resume];
}

-(void)saveNewFeed:(NSDictionary*)feedDict forRSSItem:(RSSItem*)item
{
     if ( item.updateDate && ([feedDict[@"pubDate"] compare:item.updateDate] == NSOrderedDescending))
         return;
    
         
    NSManagedObjectContext *context = item.managedObjectContext;

    FeedItem *feed = [NSEntityDescription insertNewObjectForEntityForName:@"FeedItem"
                                             inManagedObjectContext: context];
    feed.title = feedDict[@"title"];
    feed.content = feedDict[@"description"];
    
    if (![feedDict[@"pubDate"] isEqualToDate:[NSDate dateWithTimeIntervalSince1970:0]])
        feed.published = feedDict[@"pubDate"];
    
    NSManagedObjectID *moID = [item objectID];
    NSString *uniqueStringKey = [moID.URIRepresentation.absoluteString lastPathComponent];
    feed.rssID = uniqueStringKey;
    
    if (!item.updateDate || [feedDict[@"pubDate"] compare:item.updateDate] == NSOrderedAscending)
        item.updateDate = feedDict[@"pubDate"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Core data error %@, %@", error, [error userInfo]);
        abort();
    }
}


- (NSArray*)parseRss:(GDataXMLElement *)rootElement{
    
    NSMutableArray *feeds = [[NSMutableArray alloc] init];
    NSArray *channels = [rootElement elementsForName:@"channel"];
    for (GDataXMLElement *channel in channels) {
        
        NSArray *items = [channel elementsForName:@"item"];
        for (GDataXMLElement *item in items) {
            
            NSString *articleTitle = [[item valueForChild:@"title"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ?: @"";
            NSString *articleText = [[item valueForChild:@"description"] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ?: @"";
            NSString *dateString = [[item valueForChild:@"pubDate"]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] ?: @"";
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"EEE, dd MMM yyyy HH:mm:ss Z"];
            NSDate *dateFromString = [[NSDate alloc] init];
            
            NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
            [dateFormatter setLocale:enUSPOSIXLocale];
            
            dateFromString = [dateFormatter dateFromString:[dateString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]];
            dateFromString = (dateFromString ?: [NSDate dateWithTimeIntervalSince1970:0]);
            
            [feeds addObject: @{@"title": articleTitle, @"description": articleText, @"pubDate": dateFromString}];
        }
    }
    return feeds;
}

#pragma mark - fetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"RSSItem" inManagedObjectContext:managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                              initWithKey:@"updateDate" ascending:NO];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    
    NSFetchedResultsController *theFetchedResultsController =
    [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                        managedObjectContext:managedObjectContext sectionNameKeyPath:nil
                                                   cacheName:@"Root"];
    self.fetchedResultsController = theFetchedResultsController;
    _fetchedResultsController.delegate = self;
    
    return _fetchedResultsController;
    
}

@end
