//
//  RSSFeedCell.m
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "RSSFeedCell.h"
#import "FeedItem.h"


#define MAX_WIDTH_LABEL         280
#define LABEL_FONT_SIZE         15


@implementation RSSFeedCell

@synthesize rssTitleLabel = _rssTitleLabel;
@synthesize rssTextLabel = _rssTextLabel;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat) getCellHeight:(FeedItem*)item
{
    CGRect rectTitle = [item.title boundingRectWithSize:CGSizeMake(MAX_WIDTH_LABEL, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:LABEL_FONT_SIZE] } context:nil];
    
    CGRect rectText = [item.content boundingRectWithSize:CGSizeMake(MAX_WIDTH_LABEL, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{ NSFontAttributeName : [UIFont systemFontOfSize:LABEL_FONT_SIZE] } context:nil];
    
    CGFloat height = rectTitle.size.height + rectText.size.height;
    
    return height;
}

@end
