//
//  BTAddFriendViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAddFriendViewController.h"

@interface BTAddFriendViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *searchContent;
@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation BTAddFriendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.searchContent];
    [self.view addSubview:self.searchButton];
    [self.view addSubview:self.tableView];
}

- (void)viewDidLayoutSubviews {
    WS(weakSelf);
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(5.0f);
        make.right.equalTo(weakSelf.view).offset(-5.0f);
        make.width.equalTo(@(50));
        make.height.equalTo(@(44));
    }];
    
    [self.searchContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchButton);
        make.left.equalTo(weakSelf.view).offset(5.0f);
        make.right.equalTo(weakSelf.searchButton).offset(-(50 + 5));
        make.height.equalTo(@(44));
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.searchContent).offset(44.0f);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.bottom.equalTo(weakSelf.view);

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma -mark click event

- (void)searchButtonClick {

}


#pragma -mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] init];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma  -mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITextField *)searchContent {
    if (!_searchContent) {
        _searchContent = [[UITextField alloc] init];
        _searchContent.backgroundColor = [UIColor whiteColor];
        _searchContent.placeholder = @"请输入要查寻的账号";
        [_searchContent setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:4];
    }
    return _searchContent;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [[UIButton alloc] init];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchButtonClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

@end
