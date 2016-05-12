//
//  BTTimelineDetailViewController.m
//  BeautifulTimes
//
//  Created by 邓永豪 on 16/3/24.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTTimelineDetailViewController.h"
#import "BTTimelineEditViewController.h"
#import "BTTimelineViewController.h"
#import "BTTimelineDBManager.h"

@interface BTTimelineDetailViewController () <UIActionSheetDelegate>

@property (nonatomic, strong) UIActionSheet * selectActionSheet;

@end

@implementation BTTimelineDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"时光轴详情";
    [self.finishButton setTitle:@"编辑" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:nil
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"修改点滴"];
    [actionSheet addButtonWithTitle:@"删除点滴"];
    [actionSheet addButtonWithTitle:@"取消"];
    //设置取消按钮
    actionSheet.cancelButtonIndex = actionSheet.numberOfButtons - 1;
    [actionSheet showFromRect:self.view.superview.bounds inView:self.view.superview animated:NO];
    
    if (self.selectActionSheet) {
        self.selectActionSheet = nil;
    }
    
    self.selectActionSheet = actionSheet;
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex)
    {
        return;
    }
    
    switch (buttonIndex)
    {
        case 0:
        {
            
        }
            break;
            
        case 1:
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"确定删除？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alert show];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark -
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        
    } else {
        [[BTTimelineDBManager sharedInstance] deleteTimelineWithId:[self.timeline.timelineId integerValue]];
    }
}


- (UIActionSheet *)selectActionSheet {
    if (!_selectActionSheet) {
        _selectActionSheet = [[UIActionSheet alloc] init];
    }
    return _selectActionSheet;
}

@end
