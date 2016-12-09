//
//  Person.m
//  Super Hello World
//
//  Created by Brandon Alexander on 2/23/11.
//  Copyright (c) 2011 While This, Inc. All rights reserved.
//

#import "Person.h"


@implementation Person
@dynamic firstName;
@dynamic lastName;

-(NSString *) fullName {
	return [NSString stringWithFormat:@"%@ %@", [self firstName], [self lastName]];
}

@end
