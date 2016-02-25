//
//  BTAddFriendViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/12.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTAddFriendViewController.h"
#import "BTSearchUserCell.h"
#import "MBProgressHUD+MJ.h"

@interface BTAddFriendViewController () <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UITextField *searchContent;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) BTContacterModel *selectContacter;

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
        make.top.equalTo(weakSelf.searchContent).offset(44.0f + 5);
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
    [MBProgressHUD showMessage:@"查找中..." toView:self.view];
    WS(weakSelf);
    [[BTXMPPTool sharedInstance] searchUserInfo:self.searchContent.text Success:^(NSArray *resultArray) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            weakSelf.dataSource = resultArray;
            [weakSelf.tableView reloadData];
            [MBProgressHUD hideHUDForView:weakSelf.view];
        });
    } failure:^(NSError *error) {
        [MBProgressHUD hideHUDForView:self.view];
    }];
}


#pragma -mark tableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BTSearchUserCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ksearchUserCellIndentifier"];
    if (!cell) {
        cell = [[BTSearchUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ksearchUserCellIndentifier"];
    }
    BTContacterModel *contacter = self.dataSource[indexPath.row];
    [cell bindData:contacter];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.selectContacter = self.dataSource[indexPath.row];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"是否添加该用户为好友？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

#pragma marks UIAlertViewDelegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        if (self.selectContacter) {
            BTXMPPTool *tool = [BTXMPPTool sharedInstance];
            [tool addFried:self.selectContacter.jid];
        } else {
            NSLog(@"添加好友失败");
        }
    }
}

#pragma  -mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (UITextField *)searchContent {
    if (!_searchContent) {
        _searchContent = [[UITextField alloc] init];
        _searchContent.backgroundColor = [UIColor whiteColor];
        _searchContent.placeholder = @"  请输入要查寻的账号";
        [_searchContent setBorderWithWidth:0.5 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:3];
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
