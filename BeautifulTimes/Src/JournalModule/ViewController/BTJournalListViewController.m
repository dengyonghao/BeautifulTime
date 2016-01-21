//
//  BTJournalListViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalListViewController.h"
#import "BTJournalListItem.h"
#import "Journal.h"
#import "BTJournalManager.h"
#import "BTEditJournalViewController.h"

static NSString *kJournalCellIdentifier = @"kJournalCellIdentifier";

@interface BTJournalListViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *dataSource;

@end

@implementation BTJournalListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"日记集";
    [self initDataSource];
    [self.bodyView addSubview:self.tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)initDataSource {
    NSMutableArray *arry = [[NSMutableArray alloc] init];
    [[[BTJournalManager shareInstance] getAllJournalData] enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [arry addObject:obj];
    }];
    self.dataSource = arry;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTJournalListItem *cell = [tableView dequeueReusableCellWithIdentifier:kJournalCellIdentifier];
    if (!cell) {
        cell = [[BTJournalListItem alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kJournalCellIdentifier];
    }
    [cell bindDate:self.dataSource[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTEditJournalViewController *vc = [[BTEditJournalViewController alloc] init];
    vc.journal = self.dataSource[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (NSArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    
    return _dataSource;
}

@end
