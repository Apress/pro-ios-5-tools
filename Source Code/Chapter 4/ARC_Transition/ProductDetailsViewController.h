//
//  ProductDetailsViewController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperCheckoutAPIEngine.h"
@class QuantityCell;

@interface ProductDetailsViewController : UITableViewController<SuperCheckoutAPIEngineDelegate> {
    NSDictionary *selectedProduct;
	UIView *productDetailsHeader;
	UIImageView *productImage;
	UILabel *productNameLabel;
	UILabel *productPriceLabel;
	UITableViewCell *addToBasketCell;
	QuantityCell *quantityCell;
	
	SuperCheckoutAPIEngine *apiEngine;
}

@property(strong, nonatomic) NSDictionary *selectedProduct;
@property (nonatomic, strong) IBOutlet UIView *productDetailsHeader;
@property (nonatomic, strong) IBOutlet UIImageView *productImage;
@property (nonatomic, strong) IBOutlet UILabel *productNameLabel;
@property (nonatomic, strong) IBOutlet UILabel *productPriceLabel;
@property (nonatomic, strong) IBOutlet UITableViewCell *addToBasketCell;
@property (nonatomic, strong) IBOutlet QuantityCell *quantityCell;

@end
