//
//  VideosCell.h
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoModel.h"

//Protocol
@protocol CategoryRowDelegate <NSObject>
@optional

-(void)selectedCollectionData:(NSArray *)collectionData index:(int)index;

@end


@interface CategoryRow : UITableViewCell

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView2;
@property (nonatomic, weak ) id <CategoryRowDelegate> delegate;

- (void)collectionData:(VideoModel *)videoModelColledtion;

@end
