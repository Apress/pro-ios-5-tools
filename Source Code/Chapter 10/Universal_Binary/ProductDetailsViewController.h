//
//  ProductDetailsViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCheckoutAPIEngine.h"
#import "SCModalDelegate.h"
@class QuantityCell;
@class Product;

@interface ProductDetailsViewController : UIViewController<SuperCheckoutAPIEngineDelegate, SCModalDelegate, UITableViewDelegate, UITableViewDataSource, UISplitViewControllerDelegate, UIPopoverControllerDelegate> {
    Product *selectedProduct;
	UIView *productDetailsHeader;
	UIImageView *productImage;
	UILabel *productNameLabel;
	UILabel *productPriceLabel;
	UITableViewCell *addToBasketCell;
	QuantityCell *quantityCell;
	
	SuperCheckoutAPIEngine *apiEngine;
	
	UIToolbar *toolbar;
	UITableView *tableView;
	UIBarButtonItem *shoppingCartButton;
}

@property(retain, nonatomic) Product *selectedProduct;
@property (nonatomic, retain) IBOutlet UIView *productDetailsHeader;
@property (nonatomic, retain) IBOutlet UIImageView *productImage;
@property (nonatomic, retain) IBOutlet UILabel *productNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, retain) IBOutlet UITableViewCell *addToBasketCell;
@property (nonatomic, retain) IBOutlet QuantityCell *quantityCell;
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *shoppingCartButton;
- (IBAction)cartButtonPressed:(id)sender;

@end
