//
//  BTSettingViewController.m
//  BeautifulTimes
//
//  Created by deng on 16/2/16.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTSettingViewController.h"
#import "BTSettingModel.h"

@interface BTSettingViewController ()

@property (nonatomic,strong) NSMutableArray *allArr;

@end

@implementation BTSettingViewController

-(instancetype)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if(self){
        
    }
    return self;
}

-(NSMutableArray *)allArr
{
    if(!_allArr){
        _allArr = [NSMutableArray array];
    }
    return _allArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithRed:236/255.0 green:236/255.0 blue:244/255.0 alpha:1.0];
    self.tableView.contentInset = UIEdgeInsetsMake(15, 0, 5, 0);
    self.title=@"设置";
    //1.添加数组模型
    [self loadDataModel];
    
}

#pragma mark 加载数据模型
-(void)loadDataModel
{
    //1.
    BTSettingModel *accountAndSafe=[BTSettingModel settingWithTitle:@"账号与安全" detailTitle:@"未保护"];
    NSArray *oneArr = @[accountAndSafe];
    [self.allArr addObject:oneArr];
    //2.
    BTSettingModel *newMsg = [BTSettingModel settingWithTitle:@"新消息通知" detailTitle:nil];
    BTSettingModel *conseal = [BTSettingModel settingWithTitle:@"隐私" detailTitle:nil];
    BTSettingModel *common = [BTSettingModel settingWithTitle:@"通用" detailTitle:nil];
    NSArray *twoArr = @[newMsg, conseal, common];
    [self.allArr addObject:twoArr];
    //3.
    BTSettingModel *abount = [BTSettingModel settingWithTitle:@"新消息通知" detailTitle:nil];
    NSArray *threeArr = @[abount];
    [self.allArr addObject:threeArr];
    //4.
    BTSettingModel *loginOut = [BTSettingModel settingWithTitle:@"退出登录" detailTitle:nil];
    loginOut.isLoginOut = YES;
    NSArray *fourArr = @[loginOut];
    [self.allArr addObject:fourArr];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.allArr.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *arr=self.allArr[section];
    return arr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    SettingViewCell *cell=[SettingViewCell cellWithTableView:tableView indentifier:@"settingCell"];
//    NSArray *arr=self.allArr[indexPath.section];
//    BTSettingModel *model=arr[indexPath.row];
//    cell.settingModel=model;
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 2;
}
#pragma mark 单元格的点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *arr=self.allArr[indexPath.section];
    BTSettingModel *model = arr[indexPath.row];
    //退出登录操作
//    if(model.isLoginOut){
//        XmppTools *app=[XmppTools sharedxmpp];
//        [app xmppLoginOut]; //退出
//        //跳转到登录窗口
//        LoginViewController *login=[[LoginViewController alloc]init];
//        MyNavController *nav=[[MyNavController alloc]initWithRootViewController:login];
//        [self dismissViewControllerAnimated:NO completion:nil];
//        [UIApplication sharedApplication].keyWindow.rootViewController=nav;
//        
//    }
    return;
}

@end
