//
//  NewPersonViewController.h
//  Super Hello World
//
//  Created by Brandon Alexander on 2/24/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSectionCount	1
#define kRowCount		2

@class Person;

@class NewPersonViewController;

@protocol NewPersonViewControllerDelegate <NSObject>

@required
-(void) viewController:(NewPersonViewController *)vc didSaveWithPerson:(Person *)p;
-(void) viewControllerDidCancel:(NewPersonViewController *)vc;

@end

@interface NewPersonViewController : UITableViewController {
    id<NewPersonViewControllerDelegate> delegate;
	UITableViewCell *firstNameCell;
	UITableViewCell *lastNameCell;
	UITextField *firstNameInput;
	UITextField *lastNameInput;
	
	NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, assign) id<NewPersonViewControllerDelegate> delegate;
@property (nonatomic, retain) IBOutlet UITableViewCell *firstNameCell;
@property (nonatomic, retain) IBOutlet UITableViewCell *lastNameCell;
@property (nonatomic, retain) IBOutlet UITextField *firstNameInput;
@property (nonatomic, retain) IBOutlet UITextField *lastNameInput;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@end
