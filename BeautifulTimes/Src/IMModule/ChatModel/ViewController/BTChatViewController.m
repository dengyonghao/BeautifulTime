//
//  BTChatViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/11.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTChatViewController.h"
#import "BTChatToolView.h"
#import "XMPPJID.h"
#import "BTSendTextView.h"
#import "HMEmotion.h"
#import "HMEmotionKeyboard.h"
#import "HMEmotionTool.h"
#import "BTChatMessageModel.h"
#import "BTMessageFrameModel.h"
#import "BTXMPPTool.h"
#import "BTChatViewCell.h"

@interface BTChatViewController () <UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,NSFetchedResultsControllerDelegate,ChatToolViewDelegate>

//底部工具栏
@property (nonatomic,weak) BTChatToolView *chatBottom;
//查询结果集合
@property (nonatomic,strong)  NSFetchedResultsController *resultController;
//定义一个表视图
@property (nonatomic,weak) UITableView *table;
//存放messageFrameModel的数组
@property (nonatomic,strong) NSMutableArray *frameModelArr;
//内容输入框
@property (nonatomic,weak) BTSendTextView *bottomInputView;
//表情键盘
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
//用户自己的头像
@property (nonatomic,strong) NSData *headImage;

@property (nonatomic,assign) BOOL isChangeHeight;
//表视图的高
@property (nonatomic,assign) CGFloat tableViewHeight;

//是否改变键盘样式
@property (nonatomic,assign) BOOL  changeKeyboard;

@end

@implementation BTChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [super viewDidLoad];
    //设置背景颜色
    self.view.backgroundColor=[UIColor whiteColor];
    //1 添加表示图
    [self setupTableView];
    //2.加载聊天数据
//    [self loadChatData];
    //3.添加底部view
    [self setupBottomView];
    NSLog(@"%@",NSHomeDirectory());
    // 监听表情选中的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    // 监听删除按钮点击的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    //监听表情发送按钮点击
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceSend) name:FaceSendButton object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark 加载聊天数据
/*-(void)loadChatData
{
    
    NSLog(@"加载聊天数据");
    UserOperation *user=[UserOperation shareduser];
    NSString *myname=[NSString stringWithFormat:@"%@@%@",user.uname,ServerName];
    XmppTools *app=[XmppTools sharedxmpp];
    //获得用户自己的头像
    self.headImage=app.vCard.myvCardTemp.photo;
    //1.上下文
    NSManagedObjectContext *context=app.messageStroage.mainThreadManagedObjectContext;
    
    // NSLog(@"%@",context);
    //2.请求对象   XMPPMessageArchiving_Message_CoreDataObject
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    //3.过滤条件 和排序   bareJidStr(聊天的用户)  streamBareJidStr(我)
    NSPredicate *pre=[NSPredicate predicateWithFormat:@"streamBareJidStr=%@ AND bareJidStr=%@",myname,self.jid.bare];
    // NSLog(@"%@   %@",myname,self.jid.bare);
    fetch.predicate=pre;
    //排序
    NSSortDescriptor *sort=[NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetch.sortDescriptors=@[sort];
    
    // 查询
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    // 代理
    _resultController.delegate = self;
    
    [_resultController performFetch:&err];
    // NSLog(@"%@",_resultController.fetchedObjects);
    //如果有数据 就添加表示图
    if(_resultController.fetchedObjects.count){
        //1.数据转模型
        [self dataToModel];
        //
        //        //2.滚到最后一行
        [self scrollToBottom];
        
    }
    
    
    if (err) {
        NSLog(@"%@",err);
    }
    
}*/
#pragma mark 把聊天数据转成模型
-(void)dataToModel
{
    //
    for(XMPPMessageArchiving_Message_CoreDataObject *msg in _resultController.fetchedObjects){
        BTChatMessageModel *msgModel=[[BTChatMessageModel alloc] init];
        msgModel.message = msg.body;
        msgModel.time = [NSString stringWithFormat:@"%@",msg.timestamp];
        msgModel.recipient = msg.bareJidStr;
//        msgModel.friendHeadIcon = self.photo; //聊天用户的头像
        msgModel.ownHeadIcon = self.headImage;
        msgModel.hiddenTime = YES; //隐藏时间
        //是不是当前用户
        msgModel.isCurrentUser=[[msg outgoing] boolValue];
        //根据frameModel模型设置frame
        BTMessageFrameModel *frameModel = [[BTMessageFrameModel alloc]init];
        frameModel.messageModel = msgModel;
        //把frameModel添加到数组中
        [self.frameModelArr addObject:frameModel];
    }
    
}
#pragma mark 把聊天数据转成模型
-(void)dataToModelWith:(XMPPMessageArchiving_Message_CoreDataObject*)msg{
    if(msg.body!=nil){
        BTChatMessageModel *msgModel = [[BTChatMessageModel alloc] init];
        msgModel.message=msg.body;
        msgModel.time=[NSString stringWithFormat:@"%@",msg.timestamp];
        msgModel.recipient = msg.bareJidStr;
//        msgModel.otherPhoto=self.photo;
        msgModel.ownHeadIcon = self.headImage; //获得用户自己的头像
        //NSLog(@"%@",self.photo);
        msgModel.hiddenTime=YES; //隐藏时间
        //是不是当前用户
        msgModel.isCurrentUser=[[msg outgoing] boolValue];
        //根据frameModel模型设置frame
        BTMessageFrameModel *frameModel=[[BTMessageFrameModel alloc]init];
        frameModel.messageModel=msgModel;
        //把frameModel添加到数组中
        [self.frameModelArr addObject:frameModel];
        
        [self.table reloadData];
        //滚到最后一行
        [self scrollToBottom];
    }
    
}



#pragma mark 有数据来的时候
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    // NSLog(@"有很多消息");
    
    // NSLog(@"%zd",controller.fetchedObjects.count);
    XMPPMessageArchiving_Message_CoreDataObject *msg=[self.resultController.fetchedObjects lastObject];
    //转成模型  存到数组中
    [self dataToModelWith:msg];
    //如果是当前用户发送通知
    if([[msg outgoing] boolValue]){
        NSString *uname=[self cutStr:msg.bareJidStr];
        
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate=[formatter stringFromDate:msg.timestamp];
        
        NSDictionary *dict=@{@"uname":uname,@"time":strDate,@"body":msg.body,@"jid":msg.bareJid,@"user":@"this"};
        
        NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

#pragma mark 添加表视图
-(void)setupTableView
{
    if(self.table==nil) {
        UITableView *table=[[UITableView alloc]init];
        table.allowsSelection=NO;  //单元不可以被选中
        table.separatorStyle=UITableViewCellSeparatorStyleNone;  //去掉线
        CGFloat tableH=self.view.height-64-49;
        self.tableViewHeight=tableH;  //表示图的高
        table.frame=CGRectMake(0, 0, BT_SCREEN_WIDTH, tableH);
        table.delegate=self;
        table.dataSource=self;
        [self.view addSubview:table];
        self.table=table;
    }
    
}
#pragma mark 返回有多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return  self.frameModelArr.count  ;
}
#pragma mark 输入框的代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //写这个是为了不会在keyboardWillShow里面在调整tableView的高度(否则会错乱)
    self.isChangeHeight=YES;
    
    NSString *body=[self trimStr:textView.text];
    if([text isEqualToString:@"\n"]){
        //如果没有要发送的内容返回空
        if([body isEqualToString:@""]) return NO;
        //发送消息
        [self sendMsgWithText:_bottomInputView.messageText bodyType:@"text"];
        self.bottomInputView.text=nil;
        
        return NO;
    }
    return YES;
}
#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString*)bodyType{
    
    XMPPMessage *msg = [XMPPMessage messageWithType:@"chat" to:self.contacter.jid];
    
    BTXMPPTool *app=[BTXMPPTool sharedInstance];
    // 设置内容   text指纯文本  image指图片  audio指语音
    [msg addAttributeWithName:@"bodyType" stringValue:bodyType];
    [msg addBody:text];
    
    [app.xmppStream sendElement:msg];
    
}
#pragma mark 表情按钮点击发送
-(void)faceSend
{
    
    NSString *str=[self trimStr:_bottomInputView.text];
    if(str.length<1) return;
    //发送消息
    [self sendMsgWithText:_bottomInputView.messageText bodyType:@"text"];
    self.bottomInputView.text=nil;
}

#pragma mark 表示图单元
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTChatViewCell *cell=[BTChatViewCell cellWithTableView:tableView indentifier:@"chatViewCell"];
    //传递模型
    BTMessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    cell.frameModel=frameModel;
    return cell;
    
}
#pragma mark 返回单元格的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTMessageFrameModel *frameModel=self.frameModelArr[indexPath.row];
    return frameModel.cellHeight;
    
}
#pragma mark 添加底部的view
-(void)setupBottomView
{
    
    BTChatToolView *bottom = [[BTChatToolView alloc]init];
    bottom.toolInputView.delegate = self; //实现输入框的代理
    bottom.delegate = self;
    bottom.x= 0;
    bottom.y= self.view.height - 64 - bottom.height;
    [self.view addSubview:bottom];
    self.chatBottom = bottom;
    //传递输入框
    self.bottomInputView = bottom.toolInputView;
    //监听键盘的移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide:) name:UIKeyboardWillHideNotification object:nil];
}
#pragma mark 底部工具栏按钮的点击
- (void)chatToolView:(BTChatToolView *)toolView buttonTag:(ChatToolViewType)buttonTag {
    switch (buttonTag) {
        case ChatToolViewTypeEmotion:  //打开表情键盘
            [self openEmotion];
            break;
        case ChatToolViewTypeAddPicture:  //打开添加图片键盘
            [self addPicture];
            break;
        case ChatToolViewTypeAudio:
            break;
    }
}

#pragma mark 打开表情键盘
-(void)openEmotion
{
    //切换键盘
    self.changeKeyboard = YES;
    if(self.bottomInputView.inputView){  //自定义的键盘
        self.bottomInputView.inputView = nil;
        self.chatBottom.emotionStatus = NO;
    }else{  //系统自带的键盘
        
        self.bottomInputView.inputView = self.kerboard;
        self.chatBottom.emotionStatus = YES;
    }
    
    
    [self.bottomInputView resignFirstResponder];
    //切换完成
    self.changeKeyboard=NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomInputView becomeFirstResponder];
    });
    
}
#pragma mark 打开添加图片的键盘
-(void)addPicture
{
    NSLog(@"addPicture");
}
#pragma mark  键盘将要出现的时候
-(void)keybordAppear:(NSNotification*)note
{
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        //滚回最后一行
        [self scrollToBottom];
        
        self.chatBottom.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count>5){
            self.table.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
            return;
        }
        //数组中得模型数量小于等于5的话 才改变tableView的高度
        if(self.isChangeHeight==NO){
            
            if(BT_SCREEN_WIDTH<568){ //是iphone4s/4
                self.table.height=self.table.height-keyboardF.size.height;
                
            }else{  //是iphone5/5s/6/6plus
                self.table.height=self.table.height-49*0.5-keyboardF.size.height;
                //NSLog(@"iphone5/5s/6/6plus");
            }
            
            self.isChangeHeight=YES;
        }
        //
        
        
    }];
}
#pragma mark 键盘将要隐藏的时候
-(void)keybordHide:(NSNotification*)note
{
    if(self.changeKeyboard) return ;
    
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    //CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatBottom.transform=CGAffineTransformIdentity;
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count>5){
            self.table.transform=CGAffineTransformIdentity;
        }
        if(self.table.height<self.tableViewHeight){
            self.table.height=self.tableViewHeight;  //tableView回到原来的高度
        }
        
        self.isChangeHeight=NO; //设置NO当键盘keybordAppear 就又可以调整tableView的高度了
    }];
}


#pragma mark  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    
    // 1.拼接表情
    [self.bottomInputView appendEmotion:emotion];
    
    // 2.检测文字长度
    [self textViewDidChange:self.bottomInputView];
}


#pragma mark  当点击表情键盘上的删除按钮时调用

- (void)emotionDidDeleted:(NSNotification *)note
{
    // 往回删
    [self.bottomInputView deleteBackward];
}


#pragma mark  当textView的文字改变就会调用
- (void)textViewDidChange:(UITextView *)textView
{
    //self.navigationItem.rightBarButtonItem.enabled = textView.hasText;
}


#pragma mark 当时图开始滚动的时候  隐藏键盘
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}
#pragma mark 去掉两边空格的方法
-(NSString*)trimStr:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return str;
}
#pragma mark 滚到最后一行的方法
-(void)scrollToBottom
{
    //如果数组李米娜没有值 返回
    if(!self.frameModelArr.count) return;
    // 2.让tableveiw滚动到最后一行
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.frameModelArr.count -1 inSection:0];
    
    /*
     AtIndexPath: 要滚动到哪一行
     atScrollPosition:滚动到哪一行的什么位置
     animated:是否需要滚动动画
     */
    // NSLog(@"%zd  数组个数%zd",path.row,self.frameModelArr.count);
    
    [self.table scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr=[str componentsSeparatedByString:@"@"];
    return arr[0];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

-(NSMutableArray *)frameModelArr
{
    if(_frameModelArr==nil){
        _frameModelArr=[NSMutableArray array];
    }
    return _frameModelArr;
}

- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = BT_SCREEN_WIDTH;
        self.kerboard.height = 216;
    }
    return _kerboard;
}


@end
