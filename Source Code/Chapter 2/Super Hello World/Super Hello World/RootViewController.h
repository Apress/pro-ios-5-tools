//
//  RootViewController.h
//  Super Hello World
//
//  Created by Brandon Alexander on 2/21/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <CoreData/CoreData.h>
#import "NewPersonViewController.h"
@interface RootViewController : UITableViewController <NSFetchedResultsControllerDelegate, NewPersonViewControllerDelegate> {

}

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
