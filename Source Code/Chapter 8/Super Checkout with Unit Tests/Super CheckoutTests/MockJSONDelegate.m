//
//  MockJSONDelegate.m
//  Super Checkout
//
//  Created by Brad on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MockJSONDelegate.h"

@implementation MockJSONDelegate
@synthesize identifier;
@synthesize responseType;
@synthesize parsedObject;
@synthesize error;

-(void)parsingSucceededForRequest:(NSString *)anIdentifier 
				   ofResponseType:(SuperCheckoutResponseType)aResponseType 
					parsedObjects:(NSDictionary *)aParsedObject {
	self.identifier = anIdentifier;
	self.responseType = aResponseType;
	self.parsedObject = aParsedObject;
}



- (void)parsingFailedForRequest:(NSString *)aIdentifier 
				 ofResponseType:(SuperCheckoutResponseType)aResponseType 
						  error:(NSError *)aError {
	
	self.identifier = aIdentifier;
	self.responseType = aResponseType;
	self.error = aError;
	
}

@end
