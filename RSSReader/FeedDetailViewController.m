//
//  FeedDetailViewController.m
//  RSSReader
//
//  Created by kris on 3/27/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "FeedDetailViewController.h"

@interface FeedDetailViewController ()

@property (nonatomic, weak) IBOutlet  UIWebView *webView;

@end

@implementation FeedDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.webView loadHTMLString:self.articleString baseURL:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
