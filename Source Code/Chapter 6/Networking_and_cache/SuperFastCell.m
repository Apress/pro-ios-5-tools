//
//  SuperFastCell.m
//  Super Checkout
//
//  Created by Brandon Alexander on 4/13/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "SuperFastCell.h"

@class SuperFastCell;

@interface SuperFastCellView : UIView
@end

@implementation SuperFastCellView

- (void)drawRect:(CGRect)r {
	[(SuperFastCell *)[self superview] drawCellView:r];
}

@end

@implementation SuperFastCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        contentView = [[SuperFastCellView alloc] initWithFrame:CGRectZero];
        contentView.opaque = YES;
        contentView.backgroundColor = [UIColor whiteColor];
        [self addSubview:contentView];
        [contentView release];
    }
    return self;
}

- (void) setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGRect myBounds = [self bounds];
    myBounds.size.height -= 1;
    [contentView setFrame:myBounds];
}

- (void) setNeedsDisplay {
    [super setNeedsDisplay];
    [contentView setNeedsDisplay];
}

-(void) drawCellView:(CGRect)rect {
    
}

- (void)dealloc {
    [super dealloc];
}

@end
