//
//  Settings+CoreDataProperties.h
//  
//
//  Created by Anish Kumar on 8/10/17.
//
//

#import "Settings+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Settings (CoreDataProperties)

+ (NSFetchRequest<Settings *> *)fetchRequest;

@property (nonatomic) BOOL wiFIState;
@property (nonatomic) BOOL cellularState;
@property (nonatomic) float diskSpaceAllocated;

@end

NS_ASSUME_NONNULL_END
