//
//  SuperCheckoutAPIEngine.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SuperCheckoutAPIEngineDelegate.h"
#import "SCJSONParser.h"
@interface SuperCheckoutAPIEngine : NSObject<SCJSONParserDelegate> {
	
    NSMutableDictionary *connections;   // MGTwitterHTTPURLConnection objects
	NSString *APIDomain;
}

@property (nonatomic, strong) NSObject<SuperCheckoutAPIEngineDelegate> *delegate;
@property (nonatomic, strong) NSMutableDictionary *connections;
@property (nonatomic, strong) NSString *APIDomain;

-(id)initWithDelegate:(NSObject<SuperCheckoutAPIEngineDelegate> *) theDelegate;

-(NSString *) getProducts;
-(NSString *) getImageForProduct:(NSNumber *)productId;
-(NSString *) buyProduct:(NSNumber *)productId withQuantity:(NSNumber *)quantity;
-(NSString *) removeProductFromCart:(NSNumber *)productId withQuantity:(NSNumber *)quantity;
-(NSString *) getCart;
-(NSString *) checkout;

@end
