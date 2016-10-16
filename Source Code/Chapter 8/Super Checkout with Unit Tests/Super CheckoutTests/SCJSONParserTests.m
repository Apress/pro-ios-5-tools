//
//  SCJSONParserTests.m
//  Super Checkout
//
//  Created by Brad on 9/18/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SCJSONParserTests.h"
#import "MockJSONDelegate.h"

@implementation SCJSONParserTests

- (void)testParseWithValidJSON {
	
	MockJSONDelegate *mockDelegate = [[MockJSONDelegate alloc] init];
	
	NSString *testIdentifier = @"testParseWithValidJSON";
	NSURL *testURL = [NSURL URLWithString:@"http://www.test.com"];
	NSString *jsonString = @"{ \"hello\" : \"world\" }";
	NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
	
	SCJSONParser *parser = [[SCJSONParser alloc] initWithJSON:jsonData 
													 delegate:mockDelegate 
										 connectionIdentifier:testIdentifier
												  requestType:SuperCheckoutCheckout 
												 responseType:SuperCheckoutCheckoutResponse 
														  URL:testURL];
	
	STAssertEqualObjects(mockDelegate.identifier, testIdentifier, 
						 @"Mock delegate didn't receive the identifier that was passed in");
	
	STAssertEquals(mockDelegate.responseType, SuperCheckoutCheckoutResponse, 
				   @"Mock delegate didn't receive the responseType that was passed in");
	
	STAssertEqualObjects([mockDelegate.parsedObject objectForKey:@"hello"], @"world", 
						 @"The JSON was not parsed correctly, or the delegate was given incorrect data");
	
	[parser release];	
	
}



- (void)testParseWithInvalidJSON {
	
	MockJSONDelegate *mockDelegate = [[MockJSONDelegate alloc] init];
	
	NSString *testIdentifier = @"testParseWithInvalidJSON";
	NSURL *testURL = [NSURL URLWithString:@"http://www.test.com"];
	NSString *invalidString = @"Hello World";
	NSData *invalidData = [invalidString dataUsingEncoding:NSUTF8StringEncoding];
	
	SCJSONParser *parser = [[SCJSONParser alloc] initWithJSON:invalidData 
													 delegate:mockDelegate 
										 connectionIdentifier:testIdentifier
												  requestType:SuperCheckoutCheckout 
												 responseType:SuperCheckoutCheckoutResponse 
														  URL:testURL];
	
	STAssertEqualObjects(mockDelegate.identifier, testIdentifier, 
						 @"Mock delegate didn't receive the identifier that was passed in");
	
	STAssertEquals(mockDelegate.responseType, SuperCheckoutCheckoutResponse, 
				   @"Mock delegate didn't receive the responseType that was passed in");
	
	STAssertNil(mockDelegate.parsedObject, 
				@"The JSON parser should have returned nil due to invalid input.");
	
	STAssertNotNil(mockDelegate.error,  @"JSON parser should have passed through an error");
	
	[parser release];	
	
}

@end
