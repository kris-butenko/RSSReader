//
//  RSSItem.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class FeedItem;

@interface RSSItem : NSManagedObject

@property (nonatomic, retain) NSString*     link;
@property (nonatomic, retain) NSString*     title;
@property (nonatomic, retain) NSDate*       updateDate;
@property (nonatomic, retain) NSMutableSet*      feeds;

@end

@interface RSSItem (CoreDataGeneratedAccessors)

- (void)addFeedsObject:(FeedItem *)value;
- (void)removeFeedsObject:(FeedItem *)value;
- (void)addFeeds:(NSSet *)values;
- (void)removeFeeds:(NSSet *)values;

@end
