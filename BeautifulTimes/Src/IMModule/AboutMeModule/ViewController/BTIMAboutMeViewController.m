//
//  BTIMAboutMeViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMAboutMeViewController.h"
#import "BTChatMessageCell.h"
#import "BTTableGroupModel.h"
#import "BTAboutMeCellModel.h"
#import "BTAboutMeCell.h"
#import "BTAboutMeCellModel.h"
#import "BTIMSettingViewController.h"
#import "BTXMPPTool.h"

static NSString *cellIdentifier = @"kAboutMeCell";

@interface BTIMAboutMeViewController ()

@property (nonatomic,strong)  BTAboutMeCellModel *userSetting;

@end

@implementation BTIMAboutMeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 5, 0);
    self.tableView.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
    
    //1.获得修改头像图片过来的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeHead:) name:@"changeHeadIcon" object:nil];
    BTXMPPTool *tool = [BTXMPPTool sharedInstance];
    XMPPvCardTemp *temp = tool.vCard.myvCardTemp;
    
    //1.第一个组
    BTTableGroupModel *group1=[[BTTableGroupModel alloc]init];
    BTAboutMeCellModel *userSetting= [BTAboutMeCellModel itemWithIcon:@"fts_default_headimage" title:@"用户" detailTitle:@"" vcClass:nil];
    //获得用户的头像
    userSetting.image=temp.photo;
    group1.items=@[userSetting];
    [self.datas addObject:group1];
    self.userSetting=userSetting;
    //2.第二个组
    BTTableGroupModel *group2=[[BTTableGroupModel alloc]init];
    BTAboutMeCellModel *photos=[BTAboutMeCellModel itemWithIcon:@"MoreMyAlbum" title:@"相册" detailTitle:@"" vcClass:nil];
    BTAboutMeCellModel *favar=[BTAboutMeCellModel itemWithIcon:@"MoreMyFavorites" title:@"收藏" detailTitle:@"" vcClass:nil];
    BTAboutMeCellModel *money=[BTAboutMeCellModel itemWithIcon:@"MoreMyBankCard" title:@"钱包" detailTitle:@"" vcClass:nil];
    group2.items=@[photos,favar,money];
    [self.datas addObject:group2];
    
    //3.第三个组
    BTTableGroupModel *group3=[[BTTableGroupModel alloc]init];
    BTAboutMeCellModel *face=[BTAboutMeCellModel itemWithIcon:@"MoreExpressionShops" title:@"表情" detailTitle:@"" vcClass:nil];
    group3.items=@[face];
    [self.datas addObject:group3];
    //4.第四个组
    BTTableGroupModel *group4=[[BTTableGroupModel alloc]init];
    BTAboutMeCellModel *setting=[BTAboutMeCellModel itemWithIcon:@"MoreSetting" title:@"设置" detailTitle:@"账号未保护" vcClass:[BTIMSettingViewController class]];
    group4.items=@[setting];
    [self.datas addObject:group4];
}


#pragma mark 返回多少行
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.datas.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    BTTableGroupModel *group = self.datas[section];
    
    return group.items.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTAboutMeCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kAboutMeCell"];
    if (!cell) {
        cell = [[BTAboutMeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kAboutMeCell"];
    }
    BTTableGroupModel *group = self.datas[indexPath.section];
    cell.item = group.items[indexPath.row];
    return cell;
}

#pragma mark 设置组的标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    BTTableGroupModel *group=self.datas[section];
    return group.header;
}
#pragma mark 设置组的footer标题
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    BTTableGroupModel *group = self.datas[section];
    return group.footer;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}

#pragma mark 单元格点击的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTTableGroupModel *group = self.datas[indexPath.section];
    BTAboutMeCellModel *item = group.items[indexPath.row];
    if(item.option){
        item.option(); //调用block
    }else{
        if(item.vcClass == nil) return;
        //跳转
        [self.navigationController pushViewController:[[item.vcClass alloc]init] animated:YES];
    }
}

-(void)changeHead:(NSNotification*)note
{
    NSData *data=[note object];
    self.userSetting.image=data;
    [self.tableView reloadData];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


-(NSMutableArray *)datas
{
    if(!_datas){
        _datas=[NSMutableArray array];
    }
    return _datas;
}


@end
