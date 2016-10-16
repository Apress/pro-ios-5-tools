//
//  SCJSONParser.m
//  Super Checkout
//
//  Created by Brandon Alexander on 3/7/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "SCJSONParser.h"
#import "SBJSON/JSON.h"

@implementation SCJSONParser

+(id) parserWithJSON:(NSData *)jsonData 
			delegate:(id<SCJSONParserDelegate>)delegate
connectionIdentifier:(NSString *)requestIdentifier
		 requestType:(SuperCheckoutRequestType)reqType
		responseType:(SuperCheckoutResponseType)responseType
				 URL:(NSURL *)theURL {
	return [[self alloc] initWithJSON:jsonData 
							  delegate:delegate 
				  connectionIdentifier:requestIdentifier 
						   requestType:reqType 
						  responseType:responseType 
								   URL:theURL];
}

-(id)   initWithJSON:(NSData *)jsonData 
			delegate:(id<SCJSONParserDelegate>)theDelegate
connectionIdentifier:(NSString *)requestIdentifier
		 requestType:(SuperCheckoutRequestType)reqType
		responseType:(SuperCheckoutResponseType)theResponseType
				 URL:(NSURL *)theURL {
	self = [super init];
	
	if(self) {
		//Initialization stuff
		json = jsonData;
		identifier = requestIdentifier;
		delegate = theDelegate;
		requestType = reqType;
		responseType = theResponseType;
		URL = theURL;
	
		//Do JSON parsing here
		SBJsonParser *parser = [[SBJsonParser alloc] init];
		NSString *jsonString = [[NSString alloc] initWithBytes:[json bytes] length:[json length] encoding:NSUTF8StringEncoding];
		parsedObject = (NSDictionary *)[parser objectWithString:jsonString];
		
		[delegate parsingSucceededForRequest:requestIdentifier ofResponseType:responseType parsedObjects:parsedObject];
	}
	
	return self;
}


@end
