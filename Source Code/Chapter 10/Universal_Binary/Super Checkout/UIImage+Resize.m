//
//  UIImage+Resize.m
//  Super Checkout
//
//  Created by Brandon Alexander on 4/12/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "UIImage+Resize.h"


@implementation UIImage (UIImage_Resize)

- (UIImage*) resizedImageWithSize:(CGSize)size {
	UIGraphicsBeginImageContext(size);
    
	[self drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    
	// An autoreleased image
	UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
	UIGraphicsEndImageContext();
    
	return newImage;
}

@end
