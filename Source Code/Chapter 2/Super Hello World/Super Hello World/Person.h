//
//  Person.h
//  Super Hello World
//
//  Created by Brandon Alexander on 2/23/11.
//  Copyright (c) 2011 While This, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Person : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;

-(NSString *) fullName;

@end
