//
//  Videos+CoreDataProperties.h
//  
//
//  Created by Anish Kumar on 8/3/17.
//
//

#import "Videos+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Videos (CoreDataProperties)

+ (NSFetchRequest<Videos *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *contentId;

@end

NS_ASSUME_NONNULL_END
