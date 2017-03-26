//
//  RSSTableViewController.h
//  RSSReader
//
//  Created by kris on 3/26/17.
//  Copyright © 2017 kris. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSSTableViewController : UITableViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;

@end
