//
//  RootViewController.m
//  Performance Tuning
//
//  Created by Brandon Alexander on 4/3/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController(Private)
-(NSInteger) fibonacci:(NSInteger) term;
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%i", [self fibonacci:[indexPath row]]]];

    // Configure the cell.
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - Private
-(NSInteger) fibonacci:(NSInteger) term {
    NSInteger first = 0;
    NSInteger second = 1;
    
    if(term == 0) {
        return first;
    } else if(term == 1) {
        return second;
    } else {
        NSInteger actualTerm = 0;
        for(int t = 1; t < term; t++) {
            actualTerm = first + second;
            
            first = second;
            second = actualTerm;
        }
        
        return actualTerm;
    }
}

/*
//This is the recursive implementation of the fibonacci sequence. It is SLOW on a computer....
-(NSInteger) fibonacci:(NSInteger) term {
    if(term == 0) {
        return 0;
    } else if(term == 1) { return 1;
    } else {
        return [self fibonacci:term - 1] + [self fibonacci:term - 2];
    } 
}
*/
@end
