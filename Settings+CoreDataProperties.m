//
//  Settings+CoreDataProperties.m
//  
//
//  Created by Anish Kumar on 8/10/17.
//
//

#import "Settings+CoreDataProperties.h"

@implementation Settings (CoreDataProperties)

+ (NSFetchRequest<Settings *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Settings"];
}

@dynamic wiFIState;
@dynamic cellularState;
@dynamic diskSpaceAllocated;

@end
