//
//  BTSettingModel.m
//  BeautifulTimes
//
//  Created by deng on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTSettingModel.h"

@implementation BTSettingModel

+ (instancetype)settingWithTitle:(NSString *)title detailTitle:(NSString *)detailTitle
{
    BTSettingModel *setting = [[BTSettingModel alloc] init];
    setting.title = title;
    setting.detailTitle = detailTitle;
    return setting;
}

@end
