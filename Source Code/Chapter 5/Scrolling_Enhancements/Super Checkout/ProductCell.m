//
//  ProductCell.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/8/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "ProductCell.h"
#import "Product.h"

@implementation ProductCell
@synthesize productInformation;

+(NSString *)reuseIdentifier {
    return @"ProductCell";
}

-(NSString *)reuseIdentifier {
    return [[self class] reuseIdentifier];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void) setProductInformation:(Product *)newProductInformation {
    Product *oldInfo = productInformation;
    [oldInfo removeObserver:self forKeyPath:@"productImage"];
    
    productInformation = [newProductInformation retain];
    [productInformation addObserver:self forKeyPath:@"productImage" options:NSKeyValueObservingOptionNew context:NULL];
    
    [oldInfo release];
    
    [self setNeedsDisplay];
}

- (void)setHighlighted:(BOOL)lit {
    // If highlighted state changes, need to redisplay.
    if([self isHighlighted] != lit) {
        [super setHighlighted:lit];
        [self setNeedsDisplay];
    }
}

-(void) drawCellView:(CGRect)rect {
    UIFont *font = [UIFont fontWithName:@"Helvetica" size:17.0];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
   
    CGImageRef prodImage = [[productInformation productImage] CGImage];
    CGContextDrawImage(context, CGRectMake(12, 6, 64, 64), prodImage);
    //86, 6
    //Helvetica 17 black
    CGSize textSize;
    textSize = [[productInformation name] sizeWithFont:font];
    
    if([self isHighlighted]) {
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    } else {
        CGContextSetStrokeColorWithColor(context, [[UIColor blackColor] CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    }
    
    [[productInformation name] drawInRect:CGRectMake(86, 6, textSize.width, textSize.height) withFont:font];
    
    //Helvetica 17 light gray
    NSString *priceString = [NSString stringWithFormat:@"$%1.2f", [[productInformation price] floatValue]];
    textSize = [priceString sizeWithFont:font];
    
    if([self isHighlighted]) {
        CGContextSetStrokeColorWithColor(context, [[UIColor whiteColor] CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    } else {
        CGContextSetStrokeColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
        CGContextSetFillColorWithColor(context, [[UIColor lightGrayColor] CGColor]);
    }
    [priceString drawInRect:CGRectMake(86, 35, textSize.width, textSize.height) withFont:font];
    CGContextRestoreGState(context);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"productImage"]) {
        [self setNeedsDisplay];
    }
}

- (void)dealloc {
    [super dealloc];
}

@end
