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
#import "BTChattingHistoryManager.h"

static CGFloat const KEYBOARDWIDTH = 216.0f;
static CGFloat const CHATTOOLVIEWHEIGHT = 49.0f;

@interface BTChatViewController () <UITextViewDelegate, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, ChatToolViewDelegate>

@property (nonatomic,weak) BTChatToolView *chatBottom;
@property (nonatomic,strong)  NSFetchedResultsController *resultController;
@property (nonatomic,weak) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *frameModelArr;
@property (nonatomic,weak) BTSendTextView *bottomInputView;
@property (nonatomic, strong) HMEmotionKeyboard *kerboard;
@property (nonatomic,strong) NSData *headImage;
@property (nonatomic,assign) BOOL isChangeHeight;
@property (nonatomic,assign) CGFloat tableViewHeight;
@property (nonatomic,assign) BOOL changeKeyboard;

@end

@implementation BTChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title = self.contacter.nickName;
    [self setupTableView];
    [self loadChatData];
    [self setupBottomView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidSelected:) name:HMEmotionDidSelectedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emotionDidDeleted:) name:HMEmotionDidDeletedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(faceSend) name:FaceSendButton object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark 加载聊天数据
- (void)loadChatData
{
    BTXMPPTool *xmppTool = [BTXMPPTool sharedInstance];

    self.headImage = xmppTool.vCard.myvCardTemp.photo;
    NSManagedObjectContext *context=xmppTool.messageStroage.mainThreadManagedObjectContext;
    
    NSFetchRequest *fetch=[NSFetchRequest fetchRequestWithEntityName:@"XMPPMessageArchiving_Message_CoreDataObject"];
    
    NSString *currentUser = [[NSUserDefaults standardUserDefaults] valueForKey:userID];
    NSString *currentUserJid = [NSString stringWithFormat:@"%@@%@", currentUser, ServerName];
    //bareJidStr(聊天的用户)  streamBareJidStr(我)
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"streamBareJidStr=%@ AND bareJidStr=%@", currentUserJid, self.contacter.jid.bare];
    fetch.predicate = pre;
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"timestamp" ascending:YES];
    fetch.sortDescriptors = @[sort];
    
    _resultController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetch managedObjectContext:context sectionNameKeyPath:nil cacheName:nil];
    
    NSError *err = nil;
    _resultController.delegate = self;
    
    [_resultController performFetch:&err];
    if(_resultController.fetchedObjects.count){
        [self dataToModel];
        [self scrollToBottom];
    }
    if (err) {
        NSLog(@"%@",err);
    }
}

#pragma mark 把聊天数据转成模型
-(void)dataToModel
{
    for(XMPPMessageArchiving_Message_CoreDataObject *msg in _resultController.fetchedObjects){
        BTChatMessageModel *msgModel=[[BTChatMessageModel alloc] init];
        [msgModel bindData:msg];
        
        if(self.contacter.headIcon){
            msgModel.friendHeadIcon = self.contacter.headIcon;
        } else {
            msgModel.friendHeadIcon = [UIImage imageWithData: [[BTXMPPTool sharedInstance].avatar photoDataForJID:self.contacter.jid]];
        }
        
        if (!msgModel.friendHeadIcon) {
            msgModel.friendHeadIcon = BT_LOADIMAGE(@"com_ic_defaultIcon");
        }

        msgModel.ownHeadIcon = self.headImage;
        msgModel.hiddenTime = YES;

        BTMessageFrameModel *frameModel = [[BTMessageFrameModel alloc]init];
        frameModel.messageModel = msgModel;

        [self.frameModelArr addObject:frameModel];
    }
}

#pragma mark 把聊天数据转成模型
- (void)dataToModelWith:(XMPPMessageArchiving_Message_CoreDataObject*)msg {
    if(msg.body != nil) {
        BTChatMessageModel *msgModel = [[BTChatMessageModel alloc] init];
        [msgModel bindData:msg];
        msgModel.friendHeadIcon = self.contacter.headIcon;
        msgModel.ownHeadIcon = self.headImage;
        msgModel.hiddenTime = YES;

        BTMessageFrameModel *frameModel = [[BTMessageFrameModel alloc]init];
        frameModel.messageModel = msgModel;
        [self.frameModelArr addObject:frameModel];
        
        [self.tableView reloadData];
        [self scrollToBottom];
    }
}

#pragma mark 有数据来的时候
-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    XMPPMessageArchiving_Message_CoreDataObject *msg = [self.resultController.fetchedObjects lastObject];
    [self dataToModelWith:msg];
    
    //如果是当前用户发送通知
    if([[msg outgoing] boolValue]){
        NSString *uname = [self cutStr:msg.bareJidStr];
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [formatter stringFromDate:msg.timestamp];
        
        NSDictionary *dict = @{@"uname":uname,@"time":msg.timestamp,@"body":msg.body,@"jid":msg.bareJid,@"user":@"this"};
        
        NSNotification *note = [[NSNotification alloc] initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }
}

#pragma mark 添加表视图
-(void)setupTableView
{
    if(self.tableView == nil) {
        UITableView *tableView = [[UITableView alloc]init];
        tableView.allowsSelection = NO;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        CGFloat tableViewHeight = self.view.height - 64 - CHATTOOLVIEWHEIGHT;
        self.tableViewHeight = tableViewHeight;
        tableView.frame = CGRectMake(0, 0, BT_SCREEN_WIDTH, tableViewHeight);
        tableView.delegate = self;
        tableView.dataSource = self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

#pragma mark 输入框的代理方法
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    //写这个是为了不会在keyboardWillShow里面在调整tableView的高度(否则会错乱)
    self.isChangeHeight = YES;
    
    NSString *body = [textView.text trim];
    if([text isEqualToString:@"\n"]){
        if([body isEqualToString:@""]) {
            return NO;
        }
        [self sendMsgWithText:_bottomInputView.messageText bodyType:@"text"];
        self.bottomInputView.text = nil;
        return NO;
    }
    return YES;
}

#pragma mark 发送聊天消息
-(void)sendMsgWithText:(NSString *)text bodyType:(NSString*)bodyType
{
    BTXMPPTool *xmppTool = [BTXMPPTool sharedInstance];
    [xmppTool sendMessage:text type:bodyType to:self.contacter.jid];
    NSString *friendId = [NSString stringWithFormat:@"%@", self.contacter.jid];
    BTChattingHistory *history = [[BTChattingHistory alloc] init];
    history.isCurrentUser = 1;
    history.message = text;
    history.chatTime = [[NSDate alloc] init];
    [[BTChattingHistoryManager sharedInstance] addHistoryWithFriendId:friendId message:history];
}

#pragma mark 表情按钮点击发送
-(void)faceSend
{
    NSString *str = [_bottomInputView.text trim];
    if(str.length < 1) {
      return;
    }
    [self sendMsgWithText:_bottomInputView.messageText bodyType:@"text"];
    self.bottomInputView.text = nil;
}

#pragma mark tableView delegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.frameModelArr.count  ;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTChatViewCell *cell = [BTChatViewCell cellWithTableView:tableView indentifier:@"chatViewCell"];
    BTMessageFrameModel *frameModel = self.frameModelArr[indexPath.row];
    cell.frameModel = frameModel;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BTMessageFrameModel *frameModel = self.frameModelArr[indexPath.row];
    return frameModel.cellHeight;
}

#pragma mark 添加底部的view
-(void)setupBottomView
{
    BTChatToolView *bottom = [[BTChatToolView alloc] init];
    bottom.toolInputView.delegate = self;
    bottom.delegate = self;
    bottom.x= 0; 
    bottom.y= self.view.height - 64 - bottom.height;
    [self.view addSubview:bottom];
    self.chatBottom = bottom;
    self.bottomInputView = bottom.toolInputView;
    //监听键盘的移动
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordAppear:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keybordHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark 底部工具栏按钮的点击
- (void)chatToolView:(BTChatToolView *)toolView buttonTag:(ChatToolViewType)buttonTag {
    switch (buttonTag) {
        case ChatToolViewTypeEmotion:
            [self openEmotion];
            break;
        case ChatToolViewTypeAddPicture:
            [self addPicture];
            break;
        case ChatToolViewTypeAudio:
            [self addAudio];
            break;
    }
}

#pragma mark 打开表情键盘
-(void)openEmotion
{
    self.changeKeyboard = YES;
    if(self.bottomInputView.inputView) {  //自定义的键盘
        self.bottomInputView.inputView = nil;
        self.chatBottom.emotionStatus = NO;
    } else {  //系统自带的键盘
        
        self.bottomInputView.inputView = self.kerboard;
        self.chatBottom.emotionStatus = YES;
    }
    [self.bottomInputView resignFirstResponder];
    //切换完成
    self.changeKeyboard = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.bottomInputView becomeFirstResponder];
    });
}

#pragma mark 打开添加图片的键盘
- (void)addPicture
{
    NSLog(@"addPicture");
}

#pragma mark 打开添加图片的键盘
- (void)addAudio
{
    NSLog(@"addPicture");
}


#pragma mark  键盘将要出现的时候
-(void)keybordAppear:(NSNotification*)note
{
    double duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    CGRect keyboardF=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:duration animations:^{
        [self scrollToBottom];
        
        self.chatBottom.transform=CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count > 5){
            self.tableView.transform = CGAffineTransformMakeTranslation(0, -keyboardF.size.height);
            return;
        }
        //数组中得模型数量小于等于5的话 才改变tableView的高度
        if(self.isChangeHeight == NO){
            //是iphone4s/4
            if(BT_SCREEN_WIDTH < 568){
                self.tableView.height = self.tableView.height - keyboardF.size.height;
                
            } else {
                self.tableView.height = self.tableView.height - CHATTOOLVIEWHEIGHT * 0.5 - keyboardF.size.height;
            }
            
            self.isChangeHeight = YES;
        }
    }];
}

#pragma mark 键盘将要隐藏的时候
-(void)keybordHide:(NSNotification*)note
{
    if(self.changeKeyboard) {
        return ;
    }
    double duration=[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.chatBottom.transform=CGAffineTransformIdentity;
        //如果数组中的模型大于5个的话 不需要改变高度 只改变位置
        if(self.frameModelArr.count > 5){
            self.tableView.transform = CGAffineTransformIdentity;
        }
        if(self.tableView.height < self.tableViewHeight){
            self.tableView.height = self.tableViewHeight;  //tableView回到原来的高度
        }
        self.isChangeHeight = NO; //设置NO当键盘keybordAppear 就又可以调整tableView的高度了
    }];
}

#pragma mark  当表情选中的时候调用
- (void)emotionDidSelected:(NSNotification *)note
{
    HMEmotion *emotion = note.userInfo[HMSelectedEmotion];
    [self.bottomInputView appendEmotion:emotion];
    [self textViewDidChange:self.bottomInputView];
}

#pragma mark  当点击表情键盘上的删除按钮时调用
- (void)emotionDidDeleted:(NSNotification *)note
{
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

#pragma mark 滚到最后一行的方法
-(void)scrollToBottom
{
    if(!self.frameModelArr.count) {
       return;
    }
    NSIndexPath *path = [NSIndexPath indexPathForRow:self.frameModelArr.count -1 inSection:0];
    [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma  mark 去掉@符号
-(NSString*)cutStr:(NSString*)str
{
    NSArray *arr = [str componentsSeparatedByString:@"@"];
    return arr[0];
}

-(NSMutableArray *)frameModelArr
{
    if(!_frameModelArr){
        _frameModelArr = [NSMutableArray array];
    }
    return _frameModelArr;
}

- (HMEmotionKeyboard *)kerboard
{
    if (!_kerboard) {
        self.kerboard = [HMEmotionKeyboard keyboard];
        self.kerboard.width = BT_SCREEN_WIDTH;
        self.kerboard.height = KEYBOARDWIDTH;
    }
    return _kerboard;
}

@end
