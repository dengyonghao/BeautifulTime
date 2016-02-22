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
#import "BTIMMyInfoViewController.h"

static NSString *cellIdentifier = @"kAboutMeCell";

@interface BTIMAboutMeViewController ()

@property (nonatomic,strong)  BTAboutMeCellModel *userSetting;

@end

@implementation BTIMAboutMeViewController

- (instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

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
    BTAboutMeCellModel *userSetting= [BTAboutMeCellModel itemWithIcon:@"com_ic_defaultIcon" title:@"用户" detailTitle:@"" vcClass:[BTIMMyInfoViewController class]];
    //获得用户的头像
    userSetting.image=temp.photo;
    group1.items=@[userSetting];
    [self.datas addObject:group1];
    self.userSetting=userSetting;
    
    BTTableGroupModel *group4=[[BTTableGroupModel alloc]init];
    BTAboutMeCellModel *setting=[BTAboutMeCellModel itemWithIcon:@"com_im_setting" title:@"设置" detailTitle:@"" vcClass:[BTIMSettingViewController class]];
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
