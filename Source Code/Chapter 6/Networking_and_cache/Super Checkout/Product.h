//
//  Product.h
//  Super Checkout
//
//  Created by Brandon Alexander on 4/11/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Product : NSObject {
    //{"id":"1","name":"Apple","price":"79","description":"The fruit from the original sin.","image":"http:\/\/scottpenberthy.com\/fruit\/apple.png","thumb":"http:\/\/scottpenberthy.com\/fruit\/apple.png"}
    NSString *productId;
    NSString *name;
    NSNumber *price;
    NSString *description;
    NSString *image;
    NSString *thumb;
    
    UIImage *productImage;
}

@property (nonatomic, retain) NSString *productId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *price;
@property (nonatomic, retain) NSString *description;
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSString *thumb;
@property (nonatomic, retain) UIImage *productImage;

- (id) initWithDictionary:(NSDictionary *)data;

@end
