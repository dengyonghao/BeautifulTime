//
//  BTContacterViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/24.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTContacterViewController.h"
#import "BTContacterModel.h"

@interface BTContacterViewController ()<NSFetchedResultsControllerDelegate,UISearchBarDelegate,UIAlertViewDelegate>

@property (nonatomic,strong) NSFetchedResultsController *resultsContrl;

@property (nonatomic,strong) NSMutableArray *keys ;//存放所有标示图分区的键
//定义一个字典的集合  用来存贮联系人名字拼音的首字母相同的人   一个键可以对应多个值
@property (strong,nonatomic)NSMutableDictionary *data;
//定义好友的键
@property (nonatomic,strong) NSMutableArray *otherKey;
//定义一个判断值 (好友列表在程序开启的时候只从网上加载一次)
@property (nonatomic,assign) BOOL isLoad;
//删除好友时用到的NSIndexPath
@property (nonatomic,strong) NSIndexPath *indexPath;@end

@implementation BTContacterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark 获得好朋友
-(void)getFriendData
{
    
    BTXMPPTool *xmppTool=[BTXMPPTool sharedInstance];
    //1.上下文   XMPPRoster.xcdatamodel
    NSManagedObjectContext *context = xmppTool.rosterStorage.mainThreadManagedObjectContext;
    
    //2.Fetch请求
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"XMPPUserCoreDataStorageObject"];
    //3.排序和过滤
    //    NSPredicate *pre=[NSPredicate predicateWithFormat:@"streamBareJidStr =%@",xmpp.jid];
    //    fetch.predicate=pre;
    //
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"displayName" ascending:YES];
    fetch.sortDescriptors = @[sort];
    
    //4.执行查询获取数据
    _resultsContrl = [[NSFetchedResultsController alloc]initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    _resultsContrl.delegate=self;
    //执行
    NSError *error = nil;
    [_resultsContrl performFetch:&error];
    if(error){
        NSLog(@"出现错误%@",error);
    }
    //如果数组里面有值才调用这个方法
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
        friend.jid=user.jid;
        friend.tidStr=[self cutStr:user.jidStr];
        //获得好友的头像
        if(user.photo){
            friend.headIcon = user.photo;
        }else{
            friend.headIcon = [UIImage imageWithData: [xmppToll.avatar photoDataForJID:user.jid]];
        }
        friend.nickName=user.nickname;
        // NSLog(@" %@   朋友头像%@",user.jid,data);
//        friend.vcClass = [ChatController class];
        
        //把用户名转成拼音
        if (friend.nickName == nil) {
            friend.nickName = [@"" stringByAppendingFormat:@"%@",friend.jid];
        }
        friend.py=[self hanziZpinyin:friend.nickName];
        //取出拼音首字母
        NSString *firstName=[friend.py substringToIndex:1];
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
    //NSMutableArray *newKey=[];
    for(NSString *str in key){
        if(![str isEqualToString:@"🔍"]){
            [self.otherKey addObject:str];
        }
    }
    
    NSArray *k = [self.otherKey sortedArrayUsingSelector:@selector(compare:)];
    
    [self.keys addObjectsFromArray:k];
    
    
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str {
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    return arr[0];
}
#pragma mark 把汉字转成把拼音
-(NSString *)hanziZpinyin:(NSString*)str {
    NSMutableString *ms = [[NSMutableString alloc] initWithString:str];
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO)) {
        
    }
    if (CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO)) {
        
    }
    return ms;
}
@end
