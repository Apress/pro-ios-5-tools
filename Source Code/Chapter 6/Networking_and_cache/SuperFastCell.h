//
//  SuperFastCell.h
//  Super Checkout
//
//  Created by Brandon Alexander on 4/13/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SuperFastCell : UITableViewCell {
    UIView *contentView;
}

-(void) drawCellView:(CGRect)rect;

@end
