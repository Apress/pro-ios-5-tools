//
//  Super_CheckoutViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCheckoutAPIEngineDelegate.h"
@class ProductDetailsViewController;
@class SuperCheckoutAPIEngine;
@class ProductCell;

@interface Super_CheckoutViewController : UITableViewController<SuperCheckoutAPIEngineDelegate, UIScrollViewDelegate> {
	NSArray *inventory;
	SuperCheckoutAPIEngine *apiEngine;
	
	UINib *cellNib;
	ProductCell *productCell;
	
	NSMutableDictionary *imageIndexes;
    NSMutableDictionary *imageDownloadsInProgress;
	ProductDetailsViewController *detailsViewController;
}

@property (nonatomic, retain) IBOutlet ProductCell *productCell;
@property (nonatomic, retain) IBOutlet ProductDetailsViewController *detailsViewController;

@end
