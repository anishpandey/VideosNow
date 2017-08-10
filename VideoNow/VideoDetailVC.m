//
//  VideoDetailVC.m
//  VideoNow
//
//  Created by Anish Kumar on 7/19/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "VideoDetailVC.h"
#import "VideoDetailCell.h"
#import "AVPlayerVC.h"
#import "PopOverVC.h"
#import "UIStoryboard+VN.h"
#import "VideoModelArray.h"
#import "UIImageView+WebCache.h"
#import <VocSdk/VocSdk.h>
#import "AppDelegate.h"

@interface VideoDetailVC ()<UIPopoverPresentationControllerDelegate, VideoNowPopDelegate, AVPlayerOverlayVCDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
- (IBAction)backButtonAction:(UIButton *)sender;

@property (nonatomic, strong) NSArray *sampleData;
@property (nonatomic, weak) AVPlayerVC *playerVC;

@end

@implementation VideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];

    _playerVC.overlayVC.delegate = self;

    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [self playAtIndex:_index];
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)playAtIndex:(int)index
{
    VideoModelArray *model = [_array objectAtIndex:index];
    //self.playerVC.videoURL = [NSURL URLWithString:model.videoUrl];
    
    id<VocItemVideo> item = model.item;
    
    __block NSURL* url;
    if ([item conformsToProtocol:@protocol(VocItemHLSVideo)]) {
        if([appDelegate().vocService hlsServerRunning]){
            id<VocItemHLSVideo> hlsVideo = (id<VocItemHLSVideo>) item;
            url = [[appDelegate().vocService hlsServerUrl] URLByAppendingPathComponent:hlsVideo.hlsServerRelativePath];
            if (url) {
                self.playerVC.videoURL = url;
            }
        }else{
            [appDelegate().vocService startHLSServerWithCompletion:^(BOOL success) {
                id<VocItemHLSVideo> hlsVideo = (id<VocItemHLSVideo>) item;
                url = [[appDelegate().vocService hlsServerUrl] URLByAppendingPathComponent:hlsVideo.hlsServerRelativePath];
                if (url) {
                    self.playerVC.videoURL = url;
                }
            }];
        }
    }
    else if ([item conformsToProtocol:@protocol(VocItemVideo)]){
        id<VocItemVideo> itemVideo = (id<VocItemVideo>) item;
        url = [NSURL fileURLWithPath:[itemVideo localPath]];
        if (url) {
            self.playerVC.videoURL = url;
        }
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_array count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VideoDetailCellId";
    
    VideoDetailCell *cell = (VideoDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    VideoModelArray *model = [_array objectAtIndex:[indexPath row]];
    
    [cell.videoDetailImageView sd_setImageWithURL:[NSURL URLWithString:model.thumbURL]
                           placeholderImage:[UIImage imageNamed:@"TabVideo"]];
   
    cell.videoDetailTitleLabel.text = model.videoTitle;
    cell.videoDetailDetailedLabel.text = model.videoDescription;
    [cell.videoPopUpButton addTarget:self action:@selector(presentPopover:) forControlEvents:UIControlEventTouchUpInside];
    
    if (indexPath.row == _index)
    {
        cell.backgroundColor = [UIColor redColor];
    }
    else
    {
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = (int)indexPath.row;
    [_tableView reloadData];
    [self playAtIndex:(int)indexPath.row];
}

- (void) presentPopover:(UIButton *)sender
{
    PopOverVC *buttonPopVC = [[UIStoryboard mainStoryBoard]instantiateViewControllerWithIdentifier:@"PopOverVCId"];
    buttonPopVC.delegate = self;
    buttonPopVC.modalPresentationStyle = UIModalPresentationPopover;
    buttonPopVC.popoverPresentationController.sourceView = sender;
    buttonPopVC.popoverPresentationController.sourceRect = sender.bounds;
    buttonPopVC.popoverPresentationController.permittedArrowDirections = 0;
    buttonPopVC.popoverPresentationController.delegate = self;
    [self presentViewController:buttonPopVC animated:YES completion:nil];
}

- (IBAction)backButtonAction:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)selectedType:(POP_ACTION)type
{
    NSLog(@"Action");
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[AVPlayerVC class]]) {
        _playerVC = segue.destinationViewController;
    }
    //else if ([segue.destinationViewController isKindOfClass:[TableViewController class]]) {
      //  _tableViewController = segue.destinationViewController;
   // }
}
 

@end
