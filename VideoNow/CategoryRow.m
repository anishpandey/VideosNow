//
//  VideosCell.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "CategoryRow.h"
#import "VideoCell.h"
#import "VideoModelArray.h"
#import "UIImageView+WebCache.h"

//Data
#import "AppDelegate.h"
#import "VideoModelArray.h"
#import "VideoModel.h"
#import <VocSdk/VocSdk.h>
#import "Videos+CoreDataClass.h"

@interface CategoryRow () <UICollectionViewDataSource, UICollectionViewDelegate, VocObjSetChangeListener>

@property (strong, nonatomic) NSArray *collection;
@property (strong, nonatomic) id<VocItemSet>		vocVideos2;

@end

@implementation CategoryRow

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [_collection count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell = (VideoCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"videoCell" forIndexPath:indexPath];
    
    //NSDictionary *cellData = [_collectionData objectAtIndex:[indexPath row]];
    //cell.videoTitleLabel.text = [cellData objectForKey:@"title"];
    
    VideoModelArray *model = [_collection objectAtIndex:[indexPath row]];
    // Configure the cell...
    [cell populateModel: model];
    
    UIButton *downloadButton = cell.videoDownloadButton;
    [downloadButton addTarget:self action:@selector(downloadAction:)forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionData:(VideoModel *)videoModelColledtion
{
    NSArray *videoModelArray = videoModelColledtion.content;
    _collection = videoModelArray;
    [_collectionView2 setContentOffset:CGPointZero animated:NO];
    [_collectionView2 reloadData];
    
    NSSet *distinctSet = [NSSet setWithArray:[videoModelColledtion.content valueForKeyPath:@"videoID"]];
    NSLog(@"distinctSet = %@", distinctSet);
    
    [appDelegate().vocService getItemsWithContentIds:distinctSet sourceName:@"sony" completion:^(NSError * _Nullable error, id<VocItemSet>  _Nullable itemSet)
     {
         NSLog(@"itemSet = %@", itemSet);
         //[self.view hideActivityViewWithAfterDelay:0];
         
         dispatch_async(dispatch_get_main_queue(), ^{
             
             if ([[itemSet items] count])
             {
                 int i = 0;
                 for (VideoModelArray *model  in _collection)
                 {
                     for (id<VocItemVideo> item in [itemSet items])
                     {
                         if ([model.videoID isEqualToString:item.contentId])
                         {
                             VideoModelArray *model = [_collection objectAtIndex:i];
                             model.item = item;
                             i++;
                         }
                     }
                 }
                 
                 NSLog(@"items = %@", [itemSet items]);
                 
                 //self.vocVideos2 = itemSet;
                 [self.vocVideos2 addListener:self];
                 
                 [appDelegate().vocService downloadItems:[itemSet items]
                                                 options:@{@"videoPartialDownloadLength" : @(40),
                                                           @"downloadBehavior" : @(VOCItemDownloadFullAuto)}
                                              completion:nil];
                 
                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                     NSLog(@"items = %@", itemSet);
                 });
             }
         });
     }];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"Section = %ld , Row = %ld", indexPath.section, indexPath.row);
    //NSLog(@"Collection Data = %@", _collectionData);
    
   // NSDictionary *cellData = [_collectionData objectAtIndex:[indexPath row]];
    //VideoModelArray *model = [_collectionData objectAtIndex:[indexPath row]];
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"didSelectItemFromCollectionView" object:model];
    
    
    if ([_delegate respondsToSelector:@selector(selectedCollectionData: index:)]) {
        [_delegate selectedCollectionData:_collection index:(int)indexPath.row];
    }
}

- (void)downloadAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.collectionView2];
    NSIndexPath *indexPath = [self.collectionView2 indexPathForItemAtPoint:buttonPosition];
    NSLog(@"indexPath = %@", indexPath);
    

    VideoModelArray *model = [_collection objectAtIndex:[indexPath row]];
    if (model.item)
    {
        //Save contentId to CoreData
        NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSManagedObject *entityNameObj = [NSEntityDescription insertNewObjectForEntityForName:@"Videos" inManagedObjectContext:context];
        [entityNameObj setValue:model.item.contentId forKey:@"contentId"];
        
        NSLog(@"model.item.contentId = %@", model.item.contentId);
        
        NSMergePolicy *mergePolicy = [[NSMergePolicy alloc] initWithMergeType:NSMergeByPropertyStoreTrumpMergePolicyType];
        [context setMergePolicy:mergePolicy];
        
        [((AppDelegate*)[[UIApplication sharedApplication] delegate]) saveContext];
        
        VOCNetworkSelection networkSelection = [[appDelegate().vocService config]networkSelection];
        
        
//        //Fetch
//        NSFetchRequest<Videos *> *fetchRequest = [Videos fetchRequest];
//        NSError *error ;
//        NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
//        NSLog(@"resultArray = %@", resultArray);
//        
//        for (NSManagedObject *ids in resultArray) {
//            NSLog(@"save Data = %@", [ids valueForKey:@"contentId"]);
//        }
        
//        if ([model.item state] == VOCItemDownloading)
//        {
//            [appDelegate().vocService pauseItemDownload:model.item completion:nil];
//        }
//        else
        {
            [appDelegate().vocService downloadItems:@[model.item]
                                            options:@{@"videoPartialDownloadLength" : @(0),
                                                      @"downloadBehavior" : @(VOCItemDownloadFullAuto)}
                                         completion:nil];
        }
        [self.collectionView2 reloadData];
    }
}

#pragma mark - VOC SDK change listener

- (void)vocService:(nonnull id<VocService>)vocService
   objSetDidChange:(nonnull id<VocObjSet>)objSet
             added:(nonnull NSSet *)added
           updated:(nonnull NSSet *)updated
           removed:(nonnull NSSet *)removed
     objectsBefore:(nonnull NSArray *)objectsBefore
{
    [self.collectionView2 reloadData];
}

@end
