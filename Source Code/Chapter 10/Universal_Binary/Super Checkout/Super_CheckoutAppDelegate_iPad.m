//
//  Super_CheckoutAppDelegate_iPad.m
//  Super Checkout
//
//  Created by Brandon Alexander on 5/2/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "Super_CheckoutAppDelegate_iPad.h"


@implementation Super_CheckoutAppDelegate_iPad
@synthesize splitViewController;

- (void)dealloc {
    [splitViewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window.rootViewController = self.splitViewController;
	[self.window makeKeyAndVisible];
    return YES;
}
@end
