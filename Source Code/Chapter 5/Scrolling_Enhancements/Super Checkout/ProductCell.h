//
//  ProductCell.h
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperFastCell.h"
@class Product;

@interface ProductCell : SuperFastCell {
}

+(NSString *) reuseIdentifier;

@property (nonatomic, retain) Product *productInformation;

@end
