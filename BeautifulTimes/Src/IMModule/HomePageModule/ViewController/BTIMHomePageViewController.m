//
//  BTIMHomePageViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/12/21.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTIMHomePageViewController.h"
#import "BTChatMessageCell.h"
#import "BTMessageListModel.h"
#import "BTMessageListDBTool.h"
#import "BTContacterModel.h"
#import "BTChatViewController.h"

static NSString *cellIdentifier = @"chatMessageListCell";

@interface BTIMHomePageViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation BTIMHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupSearchBar];
    [self.view addSubview:self.tableView];
    [self readChatData];
    
    //监听消息来得通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateMessage:) name:SendMsgName object:nil];
    //监听删除好友时发出的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deleteFriendHandle:) name:DeleteFriend object:nil];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    WS(weakSelf);
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark   从本地数据库中读取正在聊天的好友数据
-(void)readChatData
{
    NSArray *arr = [BTMessageListDBTool selectAllData];
    self.dataSource = [arr mutableCopy];
    //如果有未读消息的话 在标签栏下面显示未读消息
    for(BTMessageListModel *model in arr){
        if(model.badgeValue.length > 0 && ![model.badgeValue isEqualToString:@""]){
            int currentV = [model.badgeValue intValue];
//            self.messageCount+=currentV;
        }
    }
//    //如果消息数大于0
//    if(self.messageCount>0){
//        //如果消息总数大于99
//        if(self.messageCount>=99){
//            self.tabBarItem.badgeValue=@"99+";
//        }else{
//            self.tabBarItem.badgeValue=[NSString stringWithFormat:@"%d",self.messageCount];
//        }
//        
//    }
}

#pragma mark 收到新消息时更新状态
- (void)updateMessage:(NSNotification*)note {
    NSDictionary *dict = [note object];
    NSString *uname = [dict objectForKey:@"uname"];
    NSString *body = [dict objectForKey:@"body"];
    XMPPJID *jid = [dict objectForKey:@"jid"];
    NSDate *time = [dict objectForKey:@"time"];
    NSString *user = [dict objectForKey:@"user"];

    if([BTMessageListDBTool selectUname:uname]){
        dispatch_async(dispatch_get_main_queue(), ^{
            for(int i = 0; i < self.dataSource.count; i++){
                BTMessageListModel *model = self.dataSource[i];
                if([model.uname isEqualToString:uname]){
                    model.body = body;
                    model.time = time;
                    //如果是正在和我聊天的用户 才设置badgeValue
                    if([user isEqualToString:@"other"]){
                        int currentV = [model.badgeValue intValue]+1;
                        model.badgeValue = [NSString stringWithFormat:@"%d",currentV];
                    }
                    [self.dataSource removeObjectAtIndex:i];
                    [self.dataSource insertObject:model atIndex:0];
                    [self.tableView reloadData];
                    [BTMessageListDBTool updateWithName:uname detailName:body time:time badge:model.badgeValue];
                    break;
                }
            }
        });

    }else{
        dispatch_async(dispatch_get_main_queue(), ^{
            BTMessageListModel *model = [[BTMessageListModel alloc]init];
            model.uname=uname;
            model.body=body;
            model.jid=jid;
            model.time=time;
            if([user isEqualToString:@"other"]){
                model.badgeValue=@"1";
            }else{
                model.badgeValue=nil;
            }
            
            [self.dataSource insertObject:model atIndex:0];
            [self.tableView reloadData];
            [BTMessageListDBTool addHead:nil uname:uname detailName:body time:time badge:model.badgeValue xmppjid:jid];
        });
    }
}

#pragma mark 好友被删除时更新记录
- (void)deleteFriendHandle:(NSNotification*)note {
    NSString *uname = [note object];
    //初始化模型的索引
    NSInteger index=0;
    for(BTMessageListModel *model in self.dataSource){
        if([model.uname isEqualToString:uname]){
            NSLog(@"%@     %@",model.uname, uname);
            [self.dataSource removeObjectAtIndex:index];
            //从本地数据库清除
            [BTMessageListDBTool deleteWithName:uname];
            //重新刷新标示图
            [self.tableView reloadData];
        }
        index++;
    }
}

#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    UISearchBar *search=[[UISearchBar alloc]init];
    search.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, 36);
    search.barStyle = UIBarStyleDefault;
    search.backgroundColor = [UIColor whiteColor];
    //取消首字母吧大写
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.placeholder = @"搜索";
    search.layer.borderWidth = 0;
    
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH, 36)];
    searchView.backgroundColor = [[UIColor alloc] initWithRed:189 green:189 blue:195 alpha:0.7f];
    [searchView addSubview:search];
    // search.delegate=self;
    self.tableView.tableHeaderView = searchView;
}

#pragma mark - UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 64;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[BTChatMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    [cell bindData:self.dataSource[indexPath.row]];
    return cell;
}

#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTMessageListModel *model = self.dataSource[indexPath.row];
    BTContacterModel *contacter = [[BTContacterModel alloc] init];
    contacter.jid = model.jid;
    contacter.nickName = model.uname;
    BTChatViewController *chatVc = [[BTChatViewController alloc] init];
    chatVc.contacter = contacter;
    chatVc.title = contacter.friendName;
    [self.navigationController pushViewController:chatVc animated:YES];
}


#pragma -mark getter
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] init];
        _tableView.delegate = self;
        _tableView.dataSource =self;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource
{
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc] init];
    }
    return _dataSource;
}

@end
