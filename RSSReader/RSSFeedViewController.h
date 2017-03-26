//
//  RSSFeedViewController.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RSSItem;

@interface RSSFeedViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) RSSItem *rssItem;

@end
