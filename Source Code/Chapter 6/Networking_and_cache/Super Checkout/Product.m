//
//  Product.m
//  Super Checkout
//
//  Created by Brandon Alexander on 4/11/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "Product.h"


@implementation Product
@synthesize productId;
@synthesize name;
@synthesize price;
@synthesize description;
@synthesize image;
@synthesize thumb;
@synthesize productImage;

- (void)dealloc {
    [productId release], productId = nil;
    [name release], name = nil;
    [price release], price = nil;
    [description release], description = nil;
    [image release], image = nil;
    [thumb release], thumb = nil;
    [productImage release], productImage = nil;
    
    [super dealloc];
}

- (id) initWithDictionary:(NSDictionary *)data {
    self = [super init];
    
    //{"id":"1","name":"Apple","price":"79","description":"The fruit from the original sin.","image":"http:\/\/scottpenberthy.com\/fruit\/apple.png","thumb":"http:\/\/scottpenberthy.com\/fruit\/apple.png"}
    if(self) {
        productId = [[data objectForKey:@"id"] copy];
        name = [[data objectForKey:@"name"] copy];
        price = [[data objectForKey:@"price"] copy];
        description = [[data objectForKey:@"description"] copy];
        image = [[data objectForKey:@"image"] copy];
        thumb = [[data objectForKey:@"thumb"] copy];
    }
    
    return self;
}

@end
