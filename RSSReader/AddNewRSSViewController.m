//
//  AddNewRSSViewController.m
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import "AddNewRSSViewController.h"
#import "RSSDataManager.h"

@interface AddNewRSSViewController ()

@property (nonatomic, weak) IBOutlet UITextField* nameField;
@property (nonatomic, weak) IBOutlet UITextField* linkField;

@end

@implementation AddNewRSSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [[RSSDataManager shared] saveNewRSSWithTitle:self.nameField.text link:self.linkField.text];
}

@end
