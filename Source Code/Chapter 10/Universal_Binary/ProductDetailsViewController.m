//
//  ProductDetailsViewController.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "ProductDetailsViewController.h"
#import "QuantityCell.h"
#import "SuperCheckoutAPIEngine.h"
#import "Product.h"
#import "ShoppingCartViewController.h"

@interface ProductDetailsViewController()
@property (nonatomic, retain) UIPopoverController *popoverController;
@end

@implementation ProductDetailsViewController
@synthesize selectedProduct;
@synthesize productDetailsHeader;
@synthesize productImage;
@synthesize productNameLabel;
@synthesize productPriceLabel;
@synthesize addToBasketCell;
@synthesize quantityCell;
@synthesize toolbar;
@synthesize tableView;
@synthesize shoppingCartButton;

@synthesize popoverController=_myPopoverController;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
    }
    return self;
}

- (id) initWithCoder:(NSCoder *)aDecoder {
	self = [super initWithCoder:aDecoder];
	if(self) {
		apiEngine = [[SuperCheckoutAPIEngine alloc] initWithDelegate:self];
	}
	
	return self;
}

- (void)dealloc {
    apiEngine.delegate = nil;
    [apiEngine release];
    [selectedProduct release];
    [productDetailsHeader release];
    [productImage release];
    [productNameLabel release];
    [productPriceLabel release];
    [addToBasketCell release];
    [quantityCell release];
	[tableView release];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[shoppingCartButton release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Accessors/Mutators

- (void) setSelectedProduct:(Product *)aProduct {
	[self willChangeValueForKey:@"selectedProduct"];
	Product *oldProduct = selectedProduct;
	selectedProduct  = [aProduct retain];
	[oldProduct release];
	[self didChangeValueForKey:@"selectedProduct"];
	[[self tableView] reloadData];
	[apiEngine getImageForProduct:[selectedProduct image]];
	
	[productNameLabel setText:[selectedProduct name]];
	[productPriceLabel setText:[NSString stringWithFormat:@"$%1.2f", [[selectedProduct price] floatValue]]];
	
	[[self popoverController] dismissPopoverAnimated:YES];
}

#pragma mark - UITableViewDataSource Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(selectedProduct == nil) {
        return 0;
    }
	return 3;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if(section == 0) {
		return 0;
	} else {
		return 1;
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section {
	if(section == 0) {
		return [selectedProduct description];
	} else {
		return nil;
	}
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 1) {
		return quantityCell;
	} else {
		return addToBasketCell;
	}
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[aTableView deselectRowAtIndexPath:indexPath animated:YES];
	
	//Add item to cart here.....
	[apiEngine buyProduct:[selectedProduct productId] withQuantity:[NSNumber numberWithInt:[quantityCell quantity]]];
}

- (NSIndexPath *)tableView:(UITableView *)tableview willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if([indexPath section] == 2) {
		return indexPath;
	} else {
		return nil;
	}
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return productDetailsHeader;
	} else {
		return nil;
	}
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if(section == 0) {
		return [productDetailsHeader frame].size.height;
	} else {
		return 0.0;
	}
}

#pragma mark - SuperCheckoutAPIEngineDelegate Methods
- (void)requestSucceeded:(NSString *)connectionIdentifier {
}

- (void)requestFailed:(NSString *)connectionIdentifier withError:(NSError *)error {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"An error occurred adding this item" delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
	
	[alert show];
    [alert release];
}

-(void) cartContentsReceived:(NSDictionary *)cart forRequest:(NSString *)connectionIdentifier {
	NSLog(@"Shopping cart contents: %@", cart);
	NSNotification *note = [NSNotification notificationWithName:@"CartUpdated" object:[NSNumber numberWithInt:[[cart objectForKey:@"items"] count]]];
	
	[[NSNotificationCenter defaultCenter] postNotification:note];
	
	[self.navigationController popViewControllerAnimated:YES];
}

-(void) imageReceived:(UIImage *)image forRequest:(NSString *)connectionIdentifier {
	[productImage setImage:image];
}

#pragma mark - Split view support

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController: (UIPopoverController *)pc {
    barButtonItem.title = @"Products";
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items insertObject:barButtonItem atIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = pc;
}

// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    NSMutableArray *items = [[self.toolbar items] mutableCopy];
    [items removeObjectAtIndex:0];
    [self.toolbar setItems:items animated:YES];
    [items release];
    self.popoverController = nil;
}

#pragma mark - Notifications
- (void) cartUpdateNotification:(NSNotification *)note {
	//Udpate cart button
	NSNumber *cartCount = [note object];
	
	[shoppingCartButton setTitle:[NSString stringWithFormat:@"Cart (%i)", [cartCount intValue]]];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
	[self setTitle:[selectedProduct name]];
	
	if(selectedProduct != nil) {
		[productNameLabel setText:[selectedProduct name]];
		[productPriceLabel setText:[NSString stringWithFormat:@"$%1.2f", [[selectedProduct price] floatValue]]];
		
		[apiEngine getImageForProduct:[selectedProduct image]];
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cartUpdateNotification:) name:@"CartUpdated" object:nil];
}

- (void)viewDidUnload {
	[self setProductDetailsHeader:nil];
	[self setProductImage:nil];
	[self setProductNameLabel:nil];
	[self setProductPriceLabel:nil];
	[self setAddToBasketCell:nil];
	[self setQuantityCell:nil];
	[self setTableView:nil];
	
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self setShoppingCartButton:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return YES;
    }
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)cartButtonPressed:(id)sender {
	ShoppingCartViewController *cartVC = [[ShoppingCartViewController alloc] initWithNibName:@"ShoppingCartViewController" bundle:nil];
	[cartVC setDelegate:self];
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:cartVC];
	
	
	[navController setModalPresentationStyle:UIModalPresentationFormSheet];
	[self presentModalViewController:navController animated:YES];
	
	[cartVC release];
	[navController release];
}

#pragma mark - SCModalDelegate Methods
-(void) viewController:(UIViewController *)vc didFinishWithData:(id) data
{
	[self dismissModalViewControllerAnimated:YES];
}

-(void) viewControllerDidCancel:(UIViewController *)vc
{
	[self dismissModalViewControllerAnimated:YES];
}
@end
