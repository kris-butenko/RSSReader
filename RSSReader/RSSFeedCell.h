//
//  RSSFeedCell.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FeedItem;

@interface RSSFeedCell : UITableViewCell
{
    UILabel *_rssTitleLabel;
    UILabel *_rssTextLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *rssTitleLabel;
@property (nonatomic, retain) IBOutlet UILabel *rssTextLabel;

+ (CGFloat) getCellHeight:(FeedItem*)item;

@end
