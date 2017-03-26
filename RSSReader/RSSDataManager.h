//
//  RSSDataManager.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RSSItem;

@interface RSSDataManager : NSObject

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

+ (RSSDataManager*)shared;
- (NSFetchedResultsController *)fetchedResultsController;
- (void) firstFillDB;

-(RSSItem*)saveNewRSSWithTitle:(NSString*)name link:(NSString*)link;

@end
