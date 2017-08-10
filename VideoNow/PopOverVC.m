//
//  PopOverVC.m
//  VideoNow
//
//  Created by Anish Kumar on 7/26/17.
//  Copyright © 2017 Anish Kumar. All rights reserved.
//

#import "PopOverVC.h"

@interface PopOverVC ()
@property (weak, nonatomic) IBOutlet UIButton *downloadButton;
@property (weak, nonatomic) IBOutlet UIButton *otherButton;

- (IBAction)downloadAction:(UIButton *)sender;
- (IBAction)otherAction:(UIButton *)sender;

@end

@implementation PopOverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.view.superview.layer.cornerRadius = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGSize)preferredContentSize
{
    if (self.presentingViewController)
    {
        CGSize tempSize = self.presentingViewController.view.bounds.size;
        tempSize.width = 150;
        tempSize.height = 35;
        //CGSize size = [self.tableView sizeThatFits:tempSize];
        return tempSize;
    }else {
        return [super preferredContentSize];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
 
 if ([_delegate respondsToSelector:@selector(selectedType: index:)]) {
 [_delegate selectedType:_actionType index:indexPath.row];
 }
}
*/

- (IBAction)downloadAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(selectedType:)])
    {
        [self dismissViewControllerAnimated:YES completion:NULL];
        [_delegate selectedType:POP_ACTION_DOWNLOAD];
    }
}

- (IBAction)otherAction:(UIButton *)sender
{
    if ([_delegate respondsToSelector:@selector(selectedType:)]) {
        [self dismissViewControllerAnimated:YES completion:NULL];
        [_delegate selectedType:POP_ACTION_OTHER];
    }
}

@end
