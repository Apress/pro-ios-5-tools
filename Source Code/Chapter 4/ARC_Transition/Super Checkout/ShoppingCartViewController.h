//
//  ShoppingCartViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCModalDelegate.h"
#import "SuperCheckoutAPIEngine.h"

@class ProductCell;

@interface ShoppingCartViewController : UITableViewController<SuperCheckoutAPIEngineDelegate> {
	NSDictionary *shoppingCart;
	
	SuperCheckoutAPIEngine *apiEngine;

	NSMutableDictionary *imageIndexPaths;
	UIButton *checkoutButton;
	UIView *checkoutButtonView;
}


@property (nonatomic, strong) IBOutlet UIView *checkoutButtonView;
@property(strong, nonatomic) id<SCModalDelegate> delegate;
@property(unsafe_unretained, nonatomic) IBOutlet ProductCell *productCell;
- (IBAction)checkoutPressed:(id)sender;

@end
