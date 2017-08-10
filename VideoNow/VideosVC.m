//
//  FirstViewController.m
//  VideoNow
//
//  Created by Anish Kumar on 7/17/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//
//Sony 022851db16eba80a3c209a5c5b7ccca67e54c55fa6b326e01965dd55de4136df

#import "VideosVC.h"
#import "CategoryRow.h"
#import "VideoDetailVC.h"
#import "UIStoryboard+VN.h"
#import "AppDelegate.h"

//Data
#import "VNNetworkFatory.h"
#import "CategoryModel.h"
#import "VideoModelArray.h"
#import "VideoModel.h"
#import <VocSdk/VocSdk.h>
#import "VNSharedData.h"

@interface VideosVC () <CategoryRowDelegate>

@property (strong, nonatomic) NSArray *categoryModelArray;
@property (strong, nonatomic) NSArray *sampleData;
@property (nonatomic, weak) IBOutlet UITableView *tableView;

@end

@implementation VideosVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //Network calls
    [[VNNetworkFatory networkingSharedmanager] fetchtJSON:
     ^(NSArray *data)
     {
         NSLog(@"Data = %@", data);
         
         [self populateData:data];
     }
     failure:^(NSDictionary *errorDict)
     {
         //NSString *error = [errorDict objectForKey:@"message"];
          NSLog(@"failure = %@", errorDict);
     }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(userRegisteredNotification:)
                                                 name:@"userRegistered"
                                               object:nil];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];

    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didSelectItemFromCollectionView:) name:@"didSelectItemFromCollectionView" object:nil];
    
    
//    self.edgesForExtendedLayout = UIRectEdgeAll;
//    self.tableView.contentInset = UIEdgeInsetsMake(0., 0., CGRectGetHeight(self.tabBarController.tabBar.frame), 0);
}

-(void) populateData:(NSArray*)array
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        NSError *error = nil;
        NSDictionary *dict = [NSDictionary dictionaryWithObject:array forKey:@"categories"];
        CategoryModel *categoryModel = [[CategoryModel alloc] initWithDictionary:dict error:&error];
        _categoryModelArray = categoryModel.categories;
        [VNSharedData sharedManager].categoryArray = _categoryModelArray;
        
         [_tableView reloadData];
    });
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    // Background color
    view.tintColor = [UIColor clearColor];
    
    // Text Color
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setTextColor:[UIColor whiteColor]];
    
    // Another way to set the background color
    // Note: does not preserve gradient effect of original header
    // header.contentView.backgroundColor = [UIColor blackColor];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    //NSDictionary *sectionData = [self.sampleData objectAtIndex:section];
    //NSString *header = [sectionData objectForKey:@"description"];
    
    VideoModel *videoModel = [_categoryModelArray objectAtIndex:section];
    NSString *header = videoModel.category_title;
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 25.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_categoryModelArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    
    CategoryRow *cell = (CategoryRow *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
   // NSDictionary *cellData = [self.sampleData objectAtIndex:[indexPath section]];
   // NSArray *articleData = [cellData objectForKey:@"articles"];
   // [cell setCollectionData:articleData];
    
    VideoModel *videoModel = [_categoryModelArray objectAtIndex:[indexPath section]];
    cell.delegate = self;
    [cell collectionData:videoModel];
    
    return cell;
}

-(void)selectedCollectionData:(NSArray *)collectionData index:(int)index
{
    NSLog(@"Array = %@ index = %d", collectionData, index);
    
    VideoDetailVC *vc = [[UIStoryboard mainStoryBoard]instantiateViewControllerWithIdentifier:@"VideoDetailVCId"];
    vc.array = collectionData;
    vc.index = index;
    
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:NO];
}

- (void) userRegisteredNotification:(NSNotification *) notification
{
    if ([[notification name] isEqualToString:@"userRegistered"])
    {
        [self.tableView reloadData];
    }
}

@end
