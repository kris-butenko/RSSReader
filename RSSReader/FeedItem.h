//
//  FeedItem.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface FeedItem : NSManagedObject

@property (nonatomic, retain) NSString*     title;
@property (nonatomic, retain) NSString*     content;
@property (nonatomic, retain) NSDate*       published;


@end
