//
//  DownloadVC.m
//  VideoNow
//
//  Created by Anish Kumar on 7/25/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "DownloadVC.h"
#import "VideoCell.h"
#import "VideoDetailVC.h"
#import "UIStoryboard+VN.h"
#import "AppDelegate.h"
#import "DownloadCell.h"
#import "Videos+CoreDataClass.h"
#import "VNSharedData.h"
#import "VideoModel.h"

@interface DownloadVC ()<VocObjSetChangeListener>

@property (strong, nonatomic) NSArray *sampleData;
@property (strong, nonatomic) id<VocItemSet>allSet;
@property (strong, nonatomic) id<VocItemSet>downloadedSet;
@property (strong, nonatomic) id<VocItemSet>downloadingSet;
@property (strong, nonatomic) NSMutableArray *dataSetArray;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

@implementation DownloadVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    
    _dataSetArray = [NSMutableArray array];
    [appDelegate().vocService getItemsWithFilter:[VocItemFilter allWithSort:nil] completion:^(NSError * _Nullable error, id<VocItemSet>  _Nullable set) {
        
        if (error) {
            NSLog(@"Error getting items from VOC SDK %@", error);
            return ;
        }
        NSLog(@"allWithSort Count = %ld", (long) set.items.count);
        [set addListener:self]; // hookup the delegate to get a call back on successful download of the manifest items.
        _allSet = set;
        
        NSManagedObjectContext *context = ((AppDelegate*)[[UIApplication sharedApplication] delegate]).persistentContainer.viewContext;
        NSFetchRequest<Videos *> *fetchRequest = [Videos fetchRequest];
        NSArray *resultArray= [context executeFetchRequest:fetchRequest error:&error];
        
        for (id<VocItemVideo> item in [set items])
        {
            if (item.state == VOCItemDownloading || item.state == VOCItemCached || item.state == VOCItemPaused)
            {
                NSPredicate *predicate = [NSPredicate predicateWithFormat: @"contentId like %@", item.contentId];
                NSArray *filteredArray = [resultArray filteredArrayUsingPredicate:predicate];
                
//                    for (NSManagedObject *ids in resultArray)
//                    {
//                        NSLog(@"save contentId = %@", [ids valueForKey:@"contentId"]);
//                    }
                
                if ([filteredArray count] > 0)
                {
                    [_dataSetArray addObject:item];
                }
            }
        }
        [_collectionView reloadData];
    }];
    
//    [appDelegate().vocService getItemsWithFilter:[VocItemFilter itemsDownloadedWithSort:nil] completion:^(NSError * _Nullable error, id<VocItemSet>  _Nullable set) {
//        
//        if (error) {
//            NSLog(@"Error getting items from VOC SDK %@", error);
//            return ;
//        }
//        NSLog(@"itemsDownloadedWithSort Count = %ld", (long) set.items.count);
//        [set addListener:self]; // hookup the delegate to get a call back on successful download of the manifest items.
//        _downloadedSet = set;
//        
//        [_dataSetArray addObject:set];
//
//    }];
//    
//    [appDelegate().vocService getItemsWithFilter:[VocItemFilter itemsDownloadingWithSort:nil] completion:^(NSError * _Nullable error, id<VocItemSet>  _Nullable set) {
//        
//        if (error) {
//            NSLog(@"Error getting items from VOC SDK %@", error);
//            return ;
//        }
//        NSLog(@"itemsDownloadingWithSort Count = %ld", (long) set.items.count);
//        [set addListener:self]; // hookup the delegate to get a call back on successful download of the manifest items.
//        _downloadingSet = set;
//        [_dataSetArray addObject:set];
//    }];
}

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return [_dataSetArray count];
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    DownloadCell *cell = (DownloadCell*)[collectionView dequeueReusableCellWithReuseIdentifier:@"DownloadCellId" forIndexPath:indexPath];
    
    // Configure the cell...
    [cell setItem: [_dataSetArray objectAtIndex:indexPath.row]];
    
    UIButton *downloadButton = cell.downloadButton;
    [downloadButton addTarget:self action:@selector(downloadAction:)forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *deleteButton = cell.deleteButton;
    [deleteButton addTarget:self action:@selector(deleteAction:)forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [self voc:indexPath];
    NSLog(@"Found item in collection = %@ & index = %d", [array objectAtIndex:0], [[array objectAtIndex:1] intValue]);
    
    VideoDetailVC *vc = [[UIStoryboard mainStoryBoard]instantiateViewControllerWithIdentifier:@"VideoDetailVCId"];
    vc.array = [array objectAtIndex:0];
    vc.index = [[array objectAtIndex:1] intValue];
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

-(NSMutableArray*)voc:(NSIndexPath*)indexPath
{
    NSMutableArray *array = [NSMutableArray array];
    
    NSArray *foundCategoryArray = nil;
    int index = 0;
    BOOL allDoneNow = NO;
    
    for (VideoModel *videoModel in [VNSharedData sharedManager].categoryArray)
    {
        NSArray *videoModelArray = videoModel.content;
        
        for (VideoModelArray *model  in videoModelArray)
        {
            id<VocItemVideo> item = model.item;
            id<VocItemVideo> itemCheck = [_dataSetArray objectAtIndex:indexPath.row];
            
            if (model.item == [_dataSetArray objectAtIndex:indexPath.row])
            {
                foundCategoryArray = videoModelArray;
                allDoneNow = YES;
                [array addObject:foundCategoryArray];
                [array addObject:[NSNumber numberWithInt:index]];
                
                return array;
                break;
            }
            else
            {
                index++;
            }
            if (allDoneNow)
                break;
        }
    }
    
    NSLog(@"Found item in collection = %@ & index = %d", foundCategoryArray, index-1);

    
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)downloadAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    
    //if ([_vocVideos2.items[indexPath.row] state] != VOCItemDownloading)
    {
        if ([[_dataSetArray objectAtIndex:indexPath.row] state] == VOCItemDownloading)
        {
            [appDelegate().vocService pauseItemDownload:[_dataSetArray objectAtIndex:indexPath.row] completion:nil];
        }
        else
        {
            [appDelegate().vocService downloadItems:@[[_dataSetArray objectAtIndex:indexPath.row]]
                                            options:@{@"videoPartialDownloadLength" : @(0),
                                                      @"downloadBehavior" : @(VOCItemDownloadFullAuto)}
                                         completion:nil];
        }
    }
    [self.collectionView reloadData];
}

- (void)deleteAction:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero
                                           toView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:buttonPosition];
    
    id<VocItem> item = [_dataSetArray objectAtIndex:indexPath.row];
    
    [item deleteFiles:NO];
    [self.collectionView reloadData];
    
    //    [appDelegate().vocService deleteFilesForItems:[NSSet setWithArray:@[self.vocVideos2.items[indexPath.row]]] options:@{@"deleteThumbnail":@(YES)} completion:^(NSError * error)
    //    {
    //        //[self.tableView reloadData];
    //    }];
    
    
}

#pragma mark - VOC SDK change listener

- (void)vocService:(nonnull id<VocService>)vocService
   objSetDidChange:(nonnull id<VocObjSet>)objSet
             added:(nonnull NSSet *)added
           updated:(nonnull NSSet *)updated
           removed:(nonnull NSSet *)removed
     objectsBefore:(nonnull NSArray *)objectsBefore
{
    [self.collectionView reloadData];
}

@end
