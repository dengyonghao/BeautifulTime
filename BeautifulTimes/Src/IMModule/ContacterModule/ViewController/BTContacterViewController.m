//
//  BTContacterViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/24.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTContacterViewController.h"
#import "BTContacterModel.h"
#import "BTContacterCell.h"
#import "BTXMPPTool.h"
#import "BTChatViewController.h"
#import "BTAddFriendViewController.h"

static NSString *kcellContacterIndentifier = @"contacterIndentifier";

@interface BTContacterViewController ()<NSFetchedResultsControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic,strong) NSFetchedResultsController *resultsContrl;

@property (nonatomic,strong) NSMutableArray *keys ;//存放所有标示图分区的键
//定义一个字典的集合  用来存贮联系人名字拼音的首字母相同的人   一个键可以对应多个值
@property (strong,nonatomic)NSMutableDictionary *data;
//定义好友的键
@property (nonatomic,strong) NSMutableArray *otherKey;
//定义一个判断值 (好友列表在程序开启的时候只从网上加载一次)
@property (nonatomic,assign) BOOL isLoad;
//删除好友时用到的NSIndexPath
@property (nonatomic,strong) NSIndexPath *indexPath;

@property (nonatomic, strong) UITableView *tableview;

@end


@implementation BTContacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupRightButtun];
    [self setupSearchBar];
    [self getFriendData];
    [self.view addSubview:self.tableview];
    [[BTXMPPTool sharedInstance] addFried:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.view).insets(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

-(void)setupRightButtun
{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:BT_LOADIMAGE(@"com_ic_nav_addfriend") style:UIBarButtonItemStylePlain target:self action:@selector(navRightClic)] ;
    
}
-(void)navRightClic
{
    BTAddFriendViewController *vc = [[BTAddFriendViewController alloc] init];
    vc.title = @"添加好友";
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 获得好朋友
-(void)getFriendData
{
    
    BTXMPPTool *xmppTool=[BTXMPPTool sharedInstance];
    NSManagedObjectContext *context = xmppTool.rosterStorage.mainThreadManagedObjectContext;
    
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    fetch.sortDescriptors = @[sort];
    
    _resultsContrl = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsContrl.delegate=self;

    NSError *error = nil;
    [_resultsContrl performFetch:&error];
    if(error){
        NSLog(@"出现错误%@",error);
    }

    if(_resultsContrl.fetchedObjects.count){
        [self devideFriend];
        self.isLoad=YES;
    }
    
    
}
#pragma mark 朋友分区 （在NSFetchRequest里面调用这个方法）
-(void)devideFriend
{
    BTXMPPTool *xmppToll=[BTXMPPTool sharedInstance];
    //获得好友的列表
    for(XMPPUserCoreDataStorageObject *user in _resultsContrl.fetchedObjects){
        
        BTContacterModel *friend = [[BTContacterModel alloc]init];
        friend.jid = user.jid;
        friend.friendName = [self cutStr:user.jidStr];

        if(user.photo){
            friend.headIcon = user.photo;
        }else{
            friend.headIcon = [UIImage imageWithData: [xmppToll.avatar photoDataForJID:user.jid]];
        }
        
        if (!friend.headIcon) {
            friend.headIcon = BT_LOADIMAGE(@"com_ic_defaultIcon");
        }
        
        friend.nickName = user.nickname;

//        friend.vcClass = [ChatController class];
        
        //把用户名转成拼音
        if (friend.nickName == nil) {
            friend.nickName = [@"" stringByAppendingFormat:@"%@",friend.jid];
        }
        friend.friendNamePinyin=[friend.nickName stringToPinyin];
        
        //取出拼音首字母x
        NSString *firstName=[friend.friendNamePinyin substringToIndex:1];
        firstName = [firstName uppercaseString]; //转成大写
        
        //获得key所对应的数据(数组)
        NSArray *arr=[self.data objectForKey:firstName];
        NSMutableArray *contacter; //临时数据
        //如果没有值
        if(arr==nil){
            contacter=[NSMutableArray arrayWithObject:friend];
        }else{
            contacter=[NSMutableArray arrayWithArray:arr];
            [contacter addObject:friend];
        }
        //设置字典的键和值
        [self.data setObject:contacter forKey:firstName];
        
    }
    //获得所有的键
    NSArray *key=[self.data allKeys];
    for(NSString *str in key){
        if(![str isEqualToString:@"🔍"]){
            [self.otherKey addObject:str];
        }
    }
    
    NSArray *k = [self.otherKey sortedArrayUsingSelector:@selector(compare:)];
    
    [self.keys addObjectsFromArray:k];
    
    
}


#pragma mark 添加搜索栏
-(void)setupSearchBar
{
    UISearchBar *search = [[UISearchBar alloc]init];
    search.frame = CGRectMake(0, 5, BT_SCREEN_WIDTH , 25);
    search.barStyle = UIBarStyleDefault;
    search.backgroundColor = [UIColor whiteColor];
    //取消首字母大写
    search.autocapitalizationType = UITextAutocapitalizationTypeNone;
    search.autocorrectionType = UITextAutocorrectionTypeNo;
    search.placeholder = @"搜索";
    search.layer.borderWidth = 0;
    
    UIView *searchV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, BT_SCREEN_WIDTH , 35)];
    searchV.backgroundColor = [UIColor grayColor];
    [searchV addSubview:search];
    search.delegate = self;
    
    self.tableview.tableHeaderView=searchV;
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str {
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    return arr[0];
}

#pragma mark - tableview delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.keys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {    
    NSString *key=self.keys[section];
    NSArray *arr=[self.data objectForKey:key];
    return arr.count;
}
#pragma mark 设置每个区的标题
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title=self.keys[section];
    return title;
}
#pragma mark 表单元的设置
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BTContacterCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellContacterIndentifier];
    if (!cell) {
        cell = [[BTContacterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcellContacterIndentifier];
    }
    NSString *key = self.keys[indexPath.section];
    NSArray *arr = [self.data objectForKey:key];
    BTContacterModel *contacter = arr[indexPath.row];
    [cell bindData:contacter];
    return cell;
}

#pragma mark 选中单元格的事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *key=self.keys[indexPath.section];
    NSArray *arr=[self.data objectForKey:key];
    BTContacterModel *contacter = arr[indexPath.row];
    BTChatViewController *chatVc = [[BTChatViewController alloc] init];
    chatVc.contacter = contacter;
    chatVc.title = contacter.friendName;
    [self.navigationController pushViewController:chatVc animated:YES];
}

#pragma mark 返回分区头的高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
#pragma mark 返回标示图的索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    return self.keys;
}
#pragma mark 滑动删除单元格
-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}
#pragma mark 改变删除单元格按钮的文字
-(NSString*)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
#pragma mark 单元格删除的点击事件
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        self.indexPath=indexPath;
        //弹出提醒框
//        [self alert];
        
    }
}

- (UITableView *)tableview {
    if (!_tableview) {
        _tableview = [[UITableView alloc] init];
        _tableview.delegate = self;
        _tableview.dataSource =self;
    }
    return _tableview;
}

-(NSMutableArray *)keys
{
    if(_keys==nil) {
        _keys=[NSMutableArray array];
    }
    return _keys;
}
-(NSMutableDictionary *)data
{
    if(_data==nil){
        _data=[NSMutableDictionary dictionary];
    }
    return _data;
}

-(NSMutableArray *)otherKey
{
    if(_otherKey==nil){
        _otherKey=[NSMutableArray array];
    }
    return _otherKey;
}

@end
