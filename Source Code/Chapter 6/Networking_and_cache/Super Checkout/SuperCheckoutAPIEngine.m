//
//  SuperCheckoutAPIEngine.m
//  Super Checkout
//
//  Created by Brandon Alexander on 1/26/11.
//  Copyright 2011 While This, Inc. All rights reserved.
//

#import "SuperCheckoutAPIEngine.h"
#import "SuperCheckoutRequestTypes.h"
#import "SCJSONParser.h"
#import "Product.h"
#import "ASIHTTPRequest.h"
#import "ASIDownloadCache.h"
#import "NSString+UUID.h"

#define HTTP_POST_METHOD        @"POST"
#define BASE_URL				@"www.scottpenberthy.com/fruit/api"
#define URL_REQUEST_TIMEOUT     25.0
#define REQUEST_TYPE            @"requestType"
#define RESPONSE_TYPE           @"responseType"
#define REQUEST_ID              @"requestIdentifier"

NSString* const APIErrorDomain = @"SuperCheckoutAPIErrorDomain";

typedef enum SuperCheckoutAPIErrorType {
    APIErrorType
} SuperCheckoutAPIErrorType;


@interface NSDictionary (MGTwitterEngineExtensions)

-(NSDictionary *)MGTE_dictionaryByRemovingObjectForKey:(NSString *)key;

@end

@interface SuperCheckoutAPIEngine ()

// Utility methods
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed;
- (NSString *)_encodeString:(NSString *)string;

// Connection/Request methods
- (NSString *)_sendRequest:(NSURL *)theURL withRequestType:(SuperCheckoutRequestType)requestType responseType:(SuperCheckoutResponseType)responseType cache:(BOOL)cache;
- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params
                                body:(NSString *)body 
                         requestType:(SuperCheckoutRequestType)requestType 
                        responseType:(SuperCheckoutResponseType)responseType;

- (NSString *)_sendImageRequestWithURL:(NSString *)imageURL;
- (NSURL *)_baseURLWithMethod:(NSString *)method 
                         path:(NSString *)path 
                  requestType:(SuperCheckoutRequestType)requestType 
              queryParameters:(NSDictionary *)params;


// Parsing methods
- (void)_parseDataForConnection:(ASIHTTPRequest *)connection;

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector;

- (NSCache *) imageCache;

@end


@implementation SuperCheckoutAPIEngine
@synthesize delegate;
@synthesize connections;

-(id)initWithDelegate:(NSObject<SuperCheckoutAPIEngineDelegate> *) theDelegate {
	self = [super init];
	
	if(self) {
		delegate = theDelegate;
    }
	
	return self;
}

// Utility methods
- (NSString *)_queryStringWithBase:(NSString *)base parameters:(NSDictionary *)params prefixed:(BOOL)prefixed
{
	// Append base if specified.
    NSMutableString *str = [NSMutableString stringWithCapacity:0];
    if (base) {
        [str appendString:base];
    }
    
    // Append each name-value pair.
    if (params) {
        NSUInteger i;
        NSArray *names = [params allKeys];
        for (i = 0; i < [names count]; i++) {
            if (i == 0 && prefixed) {
                [str appendString:@"?"];
            } else if (i > 0) {
                [str appendString:@"&"];
            }
            NSString *name = [names objectAtIndex:i];
            [str appendString:[NSString stringWithFormat:@"%@=%@", 
							   name, [self _encodeString:[params objectForKey:name]]]];
        }
    }
    
    return str;
}

- (NSString *)_encodeString:(NSString *)string
{
    NSString *result = (NSString *)CFURLCreateStringByAddingPercentEscapes(NULL, 
																		   (CFStringRef)string, 
																		   NULL, 
																		   (CFStringRef)@";/?:@&=$+{}<>,",
																		   kCFStringEncodingUTF8);
    return [result autorelease];
}

// Connection/Request methods
- (NSString*)_sendRequest:(NSURL *)theURL withRequestType:(SuperCheckoutRequestType)requestType responseType:(SuperCheckoutResponseType)responseType  cache:(BOOL)cache{
	ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:theURL];
    [request setDelegate:self];
    
    if(cache) {
        [request setDownloadCache:[ASIDownloadCache sharedCache]];        
        [request setCachePolicy:ASIAskServerIfModifiedCachePolicy|ASIFallbackToCacheIfLoadFailsCachePolicy];
        [request setCacheStoragePolicy:ASICachePermanentlyCacheStoragePolicy];
    }
    NSString *requestIdentifier = [NSString stringWithNewUUID];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                          [NSNumber numberWithInt:requestType], REQUEST_TYPE, 
                          [NSNumber numberWithInt:responseType], RESPONSE_TYPE, 
                          requestIdentifier, REQUEST_ID,
                          nil]];
    
    
    if (request == nil) {
        return nil;
    }
	
	if ([self _isValidDelegateForSelector:@selector(connectionStarted:)])
		[delegate connectionStarted:[[request requestID] stringValue]];
    
    [request startAsynchronous];
    return requestIdentifier;
}
- (NSString *)_sendRequestWithMethod:(NSString *)method 
                                path:(NSString *)path 
                     queryParameters:(NSDictionary *)params
                                body:(NSString *)body 
                         requestType:(SuperCheckoutRequestType)requestType 
                        responseType:(SuperCheckoutResponseType)responseType {
	NSURL *theUrl = [self _baseURLWithMethod:method path:path requestType:requestType queryParameters:params];
    
    return [self _sendRequest:theUrl withRequestType:requestType responseType:responseType cache:NO];
}

- (NSString *)_sendImageRequestWithURL:(NSString *)imageURL {
	NSURL *theURL = [NSURL URLWithString:imageURL];
	
    UIImage *image = [[self imageCache] objectForKey:[theURL absoluteString]];
    
    if(image) {
        NSString *requestIdentifier = [NSString stringWithNewUUID];
        
        if ([self _isValidDelegateForSelector:@selector(imageReceived:forRequest:)]) {
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1ull);
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [delegate imageReceived:image forRequest:requestIdentifier];
            });
        }
        
        return requestIdentifier;
    }
    
	return [self _sendRequest:theURL withRequestType:SuperCheckoutProductImage responseType:SuperCheckoutImage cache:YES];
}

- (NSURL *)_baseURLWithMethod:(NSString *)method 
                         path:(NSString *)path 
                  requestType:(SuperCheckoutRequestType)requestType 
              queryParameters:(NSDictionary *)params
{
    // Construct appropriate URL string.
    NSString *fullPath = [path stringByAddingPercentEscapesUsingEncoding:NSNonLossyASCIIStringEncoding];
    if (params && ![method isEqualToString:HTTP_POST_METHOD]) {
        fullPath = [self _queryStringWithBase:fullPath parameters:params prefixed:YES];
    }
    
    NSString *connectionType = @"http";
    
    NSString *urlString = nil;
    if(requestType == SuperCheckoutProductImage) {
        urlString = path;
    } else {
        urlString = [NSString stringWithFormat:@"%@://%@/%@", 
                     connectionType,
                     BASE_URL, fullPath];
    }
    
    NSURL *finalURL = [NSURL URLWithString:urlString];
    return finalURL;
}

// Parsing methods
- (void)_parseDataForConnection:(ASIHTTPRequest *)request {
	NSData *jsonData = [[[request responseData] copy] autorelease];
    NSString *identifier = [[[[request requestID] stringValue] copy] autorelease];
	
	SuperCheckoutRequestType requestType = [[[request userInfo] objectForKey:REQUEST_TYPE] intValue];
    SuperCheckoutResponseType responseType = [[[request userInfo] objectForKey:RESPONSE_TYPE] intValue];
	
    switch ([[[request userInfo] objectForKey:RESPONSE_TYPE] intValue]) {
		case SuperCheckoutProductList:
		case SuperCheckoutCartContents:
			[SCJSONParser parserWithJSON:jsonData delegate:self connectionIdentifier:identifier requestType:requestType responseType:responseType URL:nil];
			break;
			
		default:
			break;
	}
}

// Delegate methods
- (BOOL) _isValidDelegateForSelector:(SEL)selector
{
	return ((delegate != nil) && [delegate respondsToSelector:selector]);
}

#pragma mark ASIHTTPRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request {
    NSString *requestIdentifier = [[request userInfo] objectForKey:REQUEST_ID];
    if ([request responseStatusCode] >= 400) {
        // Assume failure, and report to delegate.
        NSData *receivedData = [request responseData];
        NSString *body = [receivedData length] ? [NSString stringWithUTF8String:[receivedData bytes]] : @"";
		
        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:
                                  [request responseString], @"response",
                                  body, @"body",
                                  nil];
        NSError *error = [NSError errorWithDomain:@"HTTP" code:[request responseStatusCode] userInfo:userInfo];
		if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)])
			[delegate requestFailed:requestIdentifier withError:error];
		
        // Destroy the connection.

		NSString *connectionIdentifier = requestIdentifier;
		[connections removeObjectForKey:connectionIdentifier];
		if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
			[delegate connectionFinished:connectionIdentifier];
        return;
    }
	
    NSString *connID = nil;
	SuperCheckoutResponseType responseType = 0;
	connID = requestIdentifier;
	responseType = [[[request userInfo] objectForKey:RESPONSE_TYPE] intValue];
	
    // Inform delegate.
	[delegate requestSucceeded:connID];
    
    NSData *receivedData = [request responseData];
    if (receivedData) {
        if (responseType == SuperCheckoutImage) {
			// Create image from data.
            UIImage *image = [[[UIImage alloc] initWithData:receivedData] autorelease];
            
            [[self imageCache] setObject:image forKey:[[request url] absoluteString]];
            
            // Inform delegate.
			if ([self _isValidDelegateForSelector:@selector(imageReceived:forRequest:)])
				[delegate imageReceived:image forRequest:requestIdentifier];
        } else {
            // Parse data from the connection (either XML or JSON.)
            [self _parseDataForConnection:request];
        }
    }
	
    // Release the connection.
    [connections removeObjectForKey:connID];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[delegate connectionFinished:connID];
}

- (void)requestFailed:(ASIHTTPRequest *)request {
    NSString *requestIdentifier = [[request userInfo] objectForKey:REQUEST_ID];;
	
    // Inform delegate.
	if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)]){
		[delegate requestFailed:requestIdentifier
                      withError:[request error]];
	}
    
    // Release the connection.
    [connections removeObjectForKey:requestIdentifier];
	if ([self _isValidDelegateForSelector:@selector(connectionFinished:)])
		[delegate connectionFinished:requestIdentifier];
}

#pragma mark - SCJSONParserDelegate Methods
-(void)parsingSucceededForRequest:(NSString *)identifier ofResponseType:(SuperCheckoutResponseType)responseType parsedObjects:(NSDictionary *)parsedObject {
    if([[parsedObject objectForKey:@"status"] intValue] != 0) {
        NSError *error = [NSError errorWithDomain:APIErrorDomain code:APIErrorType userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[parsedObject objectForKey:@"message"],NSLocalizedDescriptionKey,nil]];
        
        if ([self _isValidDelegateForSelector:@selector(requestFailed:withError:)]){
            [delegate requestFailed:identifier
                          withError:error];
        }

        return;
    }
    
    switch (responseType) {
        case SuperCheckoutProductList:
            if([self _isValidDelegateForSelector:@selector(productListReceived:forRequest:)]) {
                NSArray *result = [parsedObject objectForKey:@"result"];
                NSMutableArray *newResult = [NSMutableArray arrayWithCapacity:[result count]];
                
                for(NSDictionary *obj in result) {
                    Product *prod = [[Product alloc] initWithDictionary:obj];
                    
                    [newResult addObject:prod];
                    
                    [prod release];
                }
                
                
                [delegate productListReceived:[NSArray arrayWithArray:newResult] forRequest:identifier];
            }
            break;
        case SuperCheckoutCartContents:
            if([self _isValidDelegateForSelector:@selector(cartContentsReceived:forRequest:)]) {
                id cart = [parsedObject objectForKey:@"result"];
                if([cart isKindOfClass:[NSNull class]]) {
                    cart = nil;
                }
                [delegate cartContentsReceived:cart forRequest:identifier];
            }
            
        default:
            break;
    }
}

- (NSCache *) imageCache {
    static NSCache *imageCache = nil;
    
    if(imageCache == nil) {
        imageCache = [[NSCache alloc] init];
    }
    
    return imageCache;
}

#pragma mark - API Methods


-(NSString *) getProducts {
	return [self _sendRequestWithMethod:nil path:@"products" queryParameters:nil body:nil requestType:SuperCheckoutProducts responseType:SuperCheckoutProductList];
}

-(NSString *) getImageForProduct:(NSString *)imageURL {
	return [self _sendImageRequestWithURL:imageURL];
}

-(NSString *) buyProduct:(NSString *)productId withQuantity:(NSNumber *)quantity {
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	
	[options setValue:[NSString stringWithFormat:@"%i", [productId intValue]] forKey:@"id"];
	[options setValue:[NSString stringWithFormat:@"%i", [quantity intValue]] forKey:@"quantity"];
	
	return [self _sendRequestWithMethod:nil path:@"add" queryParameters:options body:nil requestType:SuperCheckoutBuy responseType:SuperCheckoutCartContents];
}

-(NSString *) removeProductFromCart:(NSNumber *)productId withQuantity:(NSNumber *)quantity {
	NSMutableDictionary *options = [NSMutableDictionary dictionary];
	
	[options setValue:[NSString stringWithFormat:@"%i", [productId intValue]] forKey:@"id"];
	[options setValue:[NSString stringWithFormat:@"%i", [quantity intValue]] forKey:@"quantity"];
	
	return [self _sendRequestWithMethod:nil path:@"delete" queryParameters:options body:nil requestType:SuperCheckoutDelete responseType:SuperCheckoutCartContents];
}

-(NSString *) getCart {
	return [self _sendRequestWithMethod:nil path:@"cart" queryParameters:nil body:nil requestType:SuperCheckoutCart responseType:SuperCheckoutCartContents];
}

-(NSString *) checkout {
	return [self _sendRequestWithMethod:nil path:@"checkout" queryParameters:nil body:nil requestType:SuperCheckoutCheckout responseType:SuperCheckoutCartContents];
}

-(void) clearCache {
    [[self imageCache] removeAllObjects];
}

-(UIImage *) cachedImageForProduct:(NSString *)stringURL {
    return [[self imageCache] objectForKey:stringURL];
}

@end
