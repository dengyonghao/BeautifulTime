//
//  BTAddressBookViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/11.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddressBookViewController.h"
#import "BTAddressBookManager.h"

@interface BTAddressBookViewController ()

@end

@implementation BTAddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSMutableArray *array = [BTAddressBookManager getAddressBookData];
    NSLog(@"-----------------------%@", array);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
