//
//  MainNavigationController.h
//  Super Checkout
//
//  Created by Brandon Alexander on 1/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCModalDelegate.h"

@interface MainNavigationController : UINavigationController<SCModalDelegate> {
	NSArray *shoppingBasket;
	UIBarButtonItem *shoppingCartButton;
}
@property (nonatomic, strong) IBOutlet UIBarButtonItem *shoppingCartButton;

-(IBAction) cartButtonPressed:(id)sender;

@end
