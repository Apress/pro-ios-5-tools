//
//  Super_CheckoutAppDelegate_iPad.h
//  Super Checkout
//
//  Created by Brandon Alexander on 5/2/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Super_CheckoutAppDelegate.h"

@interface Super_CheckoutAppDelegate_iPad : Super_CheckoutAppDelegate {

    UISplitViewController *splitViewController;
}
@property (nonatomic, retain) IBOutlet UISplitViewController *splitViewController;

@end
