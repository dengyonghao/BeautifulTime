//
//  ViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/15.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTHomePageViewController.h"
#import "BTThemeManager.h"
#import "BTRestPasswordViewController.h"
#import "BTUserLoginViewController.h"
#import "BTAddJournalViewController.h"
#import "BTMyAlbumViewController.h"
#import "BTTimelineViewController.h"
#import "BTAddTimelineViewController.h"
#import "BTUserCenterViewController.h"
#import "BTSettingViewController.h"
#import "BTJournalListViewController.h"
#import "BTUserLoginViewController.h"
#import "BTIMHomePageViewController.h"
#import "BTXMPPTool.h"
#import "BTIMTabBarController.h"
#import "AppDelegate.h"
#import "AFNetworking.h"

static const CGFloat BUTTONWIDTH = 48;

@interface BTHomePageViewController ()<BTThemeListenerProtocol>

@property (nonatomic, assign) BOOL themeInit;

@property (nonatomic, strong) UIButton *timeline;
@property (nonatomic, strong) UIButton *journals;
@property (nonatomic, strong) UIButton *album;
@property (nonatomic, strong) UIButton *chat;
@property (nonatomic, strong) UIButton *addJournal;
@property (nonatomic, strong) UIButton *addTimeline;
@property (nonatomic, strong) UIButton *reminiscence;
@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *userCenter;
@property (nonatomic, strong) UIButton *setting;

@end

@implementation BTHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.themeInit = YES;
    [self.view addSubview:self.backgroundImageView];
    [self.view addSubview:self.timeline];
    [self.view addSubview:self.album];
    [self.view addSubview:self.journals];
    [self.view addSubview:self.chat];
    [self.view addSubview:self.addJournal];
    [self.view addSubview:self.addTimeline];
    [self.view addSubview:self.reminiscence];
    [self.view addSubview:self.userCenter];
    [self.view addSubview:self.setting];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    
    [self.backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view);
        make.left.equalTo(weakSelf.view);
        make.right.equalTo(weakSelf.view);
        make.height.equalTo(weakSelf.view);
    }];
    
    CGFloat OFFSET = (BT_SCREEN_WIDTH - BUTTONWIDTH * 4) / 5;

    [self.userCenter mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(10);
        make.width.mas_equalTo(@(48));
        make.height.equalTo(@(48));
        make.top.equalTo(weakSelf.view).offset(10);
    }];
    [self.setting mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(weakSelf.view).offset(-10);
        make.width.mas_equalTo(@(48));
        make.height.equalTo(@(48));
        make.top.equalTo(weakSelf.view).offset(10);
    }];
    
    [self.timeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.view).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.album.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.album);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.view).offset(-15);
    }];
    [self.album mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.timeline.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.journals.mas_left).offset(-OFFSET);
        make.width.mas_equalTo(weakSelf.journals);
        make.height.equalTo(weakSelf.timeline);
        make.bottom.equalTo(weakSelf.timeline);

    }];
    [self.journals mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.album.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.chat.mas_left).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.chat);
        make.height.equalTo(weakSelf.album);
        make.bottom.equalTo(weakSelf.album);

    }];
    [self.chat mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(weakSelf.journals.mas_right).offset(OFFSET);
        make.right.mas_equalTo(weakSelf.view).offset(-OFFSET);
         make.width.mas_equalTo(weakSelf.timeline);
        make.height.equalTo(weakSelf.journals);
        make.bottom.equalTo(weakSelf.journals);

    }];
    
    [self.addJournal mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.view).offset(BT_SCREEN_WIDTH / 4);
        make.centerY.equalTo(weakSelf.view);
        make.height.equalTo(@(70));
        make.width.equalTo(@(70));
    }];
    
    [self.addTimeline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.view).offset(-BT_SCREEN_WIDTH / 4);
        make.centerY.equalTo(weakSelf.addJournal).offset(70);
        make.height.equalTo(@(70));
        make.width.equalTo(@(70));
    }];
    
    [self.reminiscence mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (self.themeInit) {
        [self BTThemeDidNeedUpdateStyle];
        self.themeInit = NO;
    }
}

- (void)BTThemeDidNeedUpdateStyle {

    WS(weakSelf);
    //启动图片
    if (BT_47INCH_SCREEN) {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_1242x2208" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];

    }
    else if (BT_55INCH_SCREEN) {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_750x1334" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];

    }
    else {
        [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
            [weakSelf.backgroundImageView setImage:image];
        }];
    }
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.timeline setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.timeline setImage:image forState:UIControlStateHighlighted];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.album setImage:image forState:UIControlStateNormal];
//    }];
//    [[BTThemeManager getInstance] BTThemeImage:@"ic_bg_main_640x960" completionHandler:^(UIImage *image) {
//        [weakSelf.album setImage:image forState:UIControlStateHighlighted];
//    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_journal" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_journal_press" completionHandler:^(UIImage *image) {
        [weakSelf.journals setImage:image forState:UIControlStateHighlighted];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_chat" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateNormal];
    }];
    [[BTThemeManager getInstance] BTThemeImage:@"ic_chat_press" completionHandler:^(UIImage *image) {
        [weakSelf.chat setImage:image forState:UIControlStateHighlighted];
    }];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addJournalClick {
    BTAddJournalViewController *vc = [[BTAddJournalViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)albumClick {
    BTMyAlbumViewController *vc = [[BTMyAlbumViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timelineClick {
    BTTimelineViewController *vc = [[BTTimelineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)addTimelineClick {
//    BTAddTimelineViewController *vc = [[BTAddTimelineViewController alloc] init];
//    [self.navigationController pushViewController:vc animated:YES];
//    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/4.ai"];
//    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
//    
//    [infoDic setObject:@"stu_id" forKey:@"120202021020"];
//    [infoDic setObject:@"password" forKey:@"120202021020"];
//    [self downloadFileWithOption:infoDic
//                   withInferface:@"http://172.18.190.122:8080/BTServer/loginAction"
//                       savedPath:savedPath
//                 downloadSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//                     NSLog(@"+++++++++%@", responseObject);
//                 } downloadFailure:^(AFHTTPRequestOperation *operation, NSError *error) {
//                     
//                 } progress:^(float progress) {
//                     
//                 }];
//    [self didClickUploadButtonAction];
//    [[BTXMPPTool sharedInstance] changePassworduseWord:@"23456"];
    [[BTXMPPTool sharedInstance] searchUserInfo:@"int" Success:^(NSArray *resultArray) {
        NSLog(@"%@", resultArray);
    } failure:^(NSError *error) {
        
    }];
    
}

- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress

{
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"POST" URLString:requestURL parameters:paramDic error:nil];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败");
        
    }];
    
    [operation start];
    
}


#pragma mark - AFNetworking上传文件
- (void)didClickUploadButtonAction{
    
    NSString *savedPath = [NSHomeDirectory() stringByAppendingString:@"/Documents/3.png"];
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    NSURL *filePath = [[NSBundle mainBundle] URLForResource:@"2" withExtension:@"png"];
    [infoDic setObject:@"stu_id" forKey:@"120202021020"];
    [infoDic setObject:@"password" forKey:@"120202021020"];
    
    AFHTTPRequestOperationManager *requestManager = [AFHTTPRequestOperationManager manager];
    requestManager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    requestManager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [requestManager POST:@"http://172.18.190.51:8080/BTServer/loginAction" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        /**
         *  appendPartWithFileURL   //  指定上传的文件
         *  name                    //  指定在服务器中获取对应文件或文本时的key
         *  fileName                //  指定上传文件的原始文件名
         *  mimeType                //  指定商家文件的MIME类型
         */
        [formData appendPartWithFileURL:filePath name:@"filePng" fileName:[NSString stringWithFormat:@"2.png"] mimeType:@"image/png" error:nil];
        NSLog(@"%@",formData);
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [[[UIAlertView alloc] initWithTitle:@"上传结果" message:[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]  delegate:self cancelButtonTitle:@"" otherButtonTitles:nil] show];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"%@",error);
        NSLog(@"获取服务器响应出错");
        
    }];
    
}

- (void)userCenterClick {
    BTUserCenterViewController *vc = [[BTUserCenterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)journalsClick {
    BTJournalListViewController *vc = [[BTJournalListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)chatClick {
    if ([[NSUserDefaults standardUserDefaults] valueForKey:userID] && [[NSUserDefaults standardUserDefaults] valueForKey:userPassword]) {
        [[BTXMPPTool sharedInstance] login:nil];
        BTIMTabBarController *tab = [[BTIMTabBarController alloc]init];
        [AppDelegate getInstance].window.rootViewController = tab;
    } else {
        BTUserLoginViewController *vc = [[BTUserLoginViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)settingClick {
    BTSettingViewController *vc = [[BTSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIButton *)userCenter {
    if (!_userCenter) {
        _userCenter = [[UIButton alloc] init];
        [_userCenter setTitle:@"我的" forState:UIControlStateNormal];
        [_userCenter setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_userCenter addTarget:self action:@selector(userCenterClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _userCenter;
}

- (UIButton *)setting {
    if (!_setting) {
        _setting = [[UIButton alloc] init];
        [_setting setTitle:@"设置" forState:UIControlStateNormal];
        [_setting setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_setting addTarget:self action:@selector(settingClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _setting;
}

- (UIButton *)timeline {
    if (!_timeline) {
        _timeline = [[UIButton alloc] init];
        [_timeline setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_timeline setTitle:@"时光轴" forState:UIControlStateNormal];
        [_timeline addTarget:self action:@selector(timelineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _timeline;
}

- (UIButton *)album {
    if (!_album) {
        _album = [[UIButton alloc] init];
        [_album setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_album setTitle:@"相册" forState:UIControlStateNormal];
        [_album addTarget:self action:@selector(albumClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _album;
}

- (UIButton *)journals {
    if (!_journals) {
        _journals = [[UIButton alloc] init];
        [_journals addTarget:self action:@selector(journalsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _journals;
}

- (UIButton *)chat {
    if (!_chat) {
        _chat = [[UIButton alloc] init];
        [_chat addTarget:self action:@selector(chatClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chat;
}

- (UIButton *)addJournal {
    if (!_addJournal) {
        _addJournal = [[UIButton alloc] init];
        [_addJournal setTitle:@"记日记" forState:UIControlStateNormal];
        _addJournal.titleLabel.font = BT_FONTSIZE(15);
        [_addJournal setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_addJournal setBackgroundImage:BT_LOADIMAGE(@"com_ic_addJournal") forState:UIControlStateNormal];
        [_addJournal addTarget:self action:@selector(addJournalClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addJournal;
}

- (UIButton *)addTimeline {
    if (!_addTimeline) {
        _addTimeline = [[UIButton alloc] init];
        [_addTimeline setTitle:@"记点滴" forState:UIControlStateNormal];
        _addTimeline.titleLabel.font = BT_FONTSIZE(15);
        [_addTimeline setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_other_d"] forState:UIControlStateNormal];
        [_addTimeline setBackgroundImage:BT_LOADIMAGE(@"com_ic_timeline") forState:UIControlStateNormal];
        [_addTimeline addTarget:self action:@selector(addTimelineClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _addTimeline;
}

- (UIButton *)reminiscence {
    if (!_reminiscence) {
        _reminiscence = [[UIButton alloc] init];
    }
    return _reminiscence;
}

- (UIImageView *)backgroundImageView {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
    }
    return _backgroundImageView;
}


@end
