//
//  Super_CheckoutViewController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Super_CheckoutViewController.h"
#import "SuperCheckoutAPIEngine.h"
#import "ProductCell.h"
#import "ProductDetailsViewController.h"
#import "Product.h"
#import "UIImage+Resize.h"

@interface Super_CheckoutViewController(Private)
- (void)loadImagesForOnscreenRows;
@end

@implementation Super_CheckoutViewController
@synthesize productCell;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//We are loading from a nib, so initWithCoder: is used
- (id) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if(self) {
        imageIndexes = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc
{
    [productCell release];
    [imageIndexes release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
    [apiEngine clearCache];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView 
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section 
{
    return [inventory count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    ProductCell *cell = (ProductCell *)[tableView dequeueReusableCellWithIdentifier:[ProductCell reuseIdentifier]];
    
    if(cell == nil) {
        //[cellNib instantiateWithOwner:self options:nil];
        //cell = productCell;
        cell = [[[ProductCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:[ProductCell reuseIdentifier]] autorelease];
    }
    Product *item = (Product *)[inventory objectAtIndex:[indexPath row]];
    
    [cell setProductInformation:item];
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    //[self setProductCell:nil];
    
    //Fetch image for the cell
    UIImage *image = [apiEngine cachedImageForProduct:[item thumb]];
    if(image == nil) {
        if (self.tableView.dragging == NO && self.tableView.decelerating == NO) {
            NSString *requestId = [apiEngine getImageForProduct:[item thumb]];
            
            [imageIndexes setObject:[NSNumber numberWithInt:[indexPath row]] forKey:requestId];
        }
    } else {
        [cell setProductImage:image];
    }
    
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ProductDetailsViewController *newVC = [[ProductDetailsViewController alloc] initWithNibName:@"ProductDetailsViewController" bundle:nil];
    
    [newVC setSelectedProduct:[inventory objectAtIndex:[indexPath row]]];
    
    [self.navigationController pushViewController:newVC animated:YES];
    [newVC release];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 76.0;
}

#pragma mark - SuperCheckoutAPIEngineDelegate Methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
    
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
    
}

-(void) productListReceived:(NSArray *)products forRequest:(NSString *)connectionIdentifier {
    NSLog(@"Products list: %@", [products description]);
    inventory = [products retain];
    [self.tableView reloadData];
}

-(void) imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[imageIndexes objectForKey:connectionIdentifier] intValue] inSection:0];
    ProductCell *prod = (ProductCell *)[[self tableView] cellForRowAtIndexPath:indexPath];
    
    [prod setProductImage:[image resizedImageWithSize:CGSizeMake(64.0, 64.0)]];
    
    [imageIndexes removeObjectForKey:connectionIdentifier];
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows {
    if ([inventory count] > 0) {
        NSArray *visiblePaths = [self.tableView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths) {
            Product *product = [inventory objectAtIndex:indexPath.row];
            
            if([product productImage] == nil) {
                NSString *requestId = [apiEngine getImageForProduct:[product thumb]];
                
                [imageIndexes setObject:[NSNumber numberWithInt:[indexPath row]] forKey:requestId]; 
            }
        }
    }
}

#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self loadImagesForOnscreenRows];
}



#pragma mark - View lifecycle

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView
 {
 }
 */

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setTitle:@"Inventory"];
    
    UIBarButtonItem *cartButton = [[UIBarButtonItem alloc] initWithTitle:@"Cart" style:UIBarButtonItemStyleBordered target:self action:@selector(cartButtonPressed:)];
    //[self.navigationItem setRightBarButtonItem:cartButton];
    [cartButton release];
    
    if(!cellNib) {
        cellNib = [[UINib nibWithNibName:@"ProductListCells" bundle:nil] retain];
    }
    
    if(!apiEngine) {
        apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
    }
    
    [apiEngine getProducts];
}

- (void)viewDidUnload
{
    [self setProductCell:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
