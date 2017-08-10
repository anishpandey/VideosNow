//
//  Videos+CoreDataProperties.m
//  
//
//  Created by Anish Kumar on 8/3/17.
//
//

#import "Videos+CoreDataProperties.h"

@implementation Videos (CoreDataProperties)

+ (NSFetchRequest<Videos *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Videos"];
}

@dynamic contentId;

@end
