//
//  NewPersonViewController.m
//  Super Hello World
//
//  Created by Brandon Alexander on 2/24/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "NewPersonViewController.h"
#import "Person.h"

@implementation NewPersonViewController
@synthesize delegate;
@synthesize firstNameCell;
@synthesize lastNameCell;
@synthesize firstNameInput;
@synthesize lastNameInput;
@synthesize managedObjectContext;

- (void)dealloc
{
	delegate = nil;
	[firstNameCell release], firstNameCell = nil;
	[lastNameCell release], lastNameCell = nil;
	[firstNameInput release], firstNameInput = nil;
	[lastNameInput release], lastNameInput = nil;
	[managedObjectContext release], managedObjectContext = nil;
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
	UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(savePressed:)];
    self.navigationItem.rightBarButtonItem = saveButton;
	[saveButton release];
	
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPressed:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
	[cancelButton release];
}

- (void)viewDidUnload
{
    [self setFirstNameCell:nil];
    [self setLastNameCell:nil];
    [self setFirstNameInput:nil];
    [self setLastNameInput:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return kSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return kRowCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	if([indexPath row] == 0) {
		return firstNameCell;
	} else {
		return lastNameCell;
	}
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //Nothing to see here, move along
}

#pragma mark - Actions received

-(void) savePressed:(id)sender {
	NSManagedObjectContext *context = [self managedObjectContext];
    
    Person *newPerson = (Person *)[NSEntityDescription insertNewObjectForEntityForName:@"Person" inManagedObjectContext:context];
	
	[newPerson setFirstName:[firstNameInput text]];
	[newPerson setLastName:[lastNameInput text]];
	
	NSError *error = nil;
    if (![context save:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
	
	[delegate viewController:self didSaveWithPerson:newPerson];
}

-(void) cancelPressed:(id)sender {
	[delegate viewControllerDidCancel:self];
}

@end
