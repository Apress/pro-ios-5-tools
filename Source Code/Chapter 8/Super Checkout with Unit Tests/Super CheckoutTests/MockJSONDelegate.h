//
//  MockJSONDelegate.h
//  Super Checkout
//
//  Created by Brad on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SCJSONParser.h"
#import "SuperCheckoutRequestTypes.h"

@interface MockJSONDelegate : NSObject <SCJSONParserDelegate>

@property (nonatomic, copy) NSString *identifier;
@property (nonatomic, assign) SuperCheckoutResponseType responseType;
@property (nonatomic, copy) NSDictionary *parsedObject;
@property (nonatomic, retain) NSError *error;

@end
