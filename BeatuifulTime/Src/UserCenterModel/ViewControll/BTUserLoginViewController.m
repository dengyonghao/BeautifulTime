//
//  BTUserLoginViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTUserLoginViewController.h"
#import "BTTextField.h"

#define margin 20
#define textFieldHeight 30

@interface BTUserLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) BTTextField *username;
@property (nonatomic,strong) BTTextField *password;

@end

@implementation BTUserLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"登陆微信";
    [self.bodyView addSubview:self.username];
    [self.view addSubview:self.username];
    [self.bodyView addSubview:self.password];
    [self.view addSubview:self.password];
    [self.bodyView addSubview:self.loginBtn];
    [self addGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf).offset(margin);
        make.left.equalTo(weakSelf).offset(margin);
        make.right.equalTo(weakSelf).offset(margin);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.username).offset(margin + textFieldHeight);
        make.left.equalTo(weakSelf.username);
        make.right.equalTo(weakSelf.username);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password).offset(margin + textFieldHeight);
        make.left.equalTo(weakSelf.password);
        make.right.equalTo(weakSelf.password);
        make.height.equalTo(@(40));
    }];
}

#pragma mark 添加手势识别器
-(void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
}
#pragma mark 点击的方法
-(void)tapClick:(id)sender
{
    [self.view endEditing:YES];
}

#pragma mark 添加下划线的方法
-(void)addbottomLineWith:(CGRect)bounds
{
    UIImageView *line=[[UIImageView alloc]initWithFrame:bounds];
    //line.width=0.5;
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
}

#pragma mark 添加注册按钮
-(void)addRegisButton:(CGRect)bounds
{
    UIButton *reg=[[UIButton alloc]initWithFrame:bounds];
//    reg.titleLabel.font=MyFont(14);
    [reg setTitle:@"注册" forState:UIControlStateNormal];
//    [reg setTitleColor:WColorAlpha(71, 61, 139, 0.8) forState:UIControlStateNormal];
//    [reg setTitleColor:WColorAlpha(0, 255, 255, 1) forState:UIControlStateHighlighted];
    [reg addTarget:self action:@selector(regisClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:reg];
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.username.text.length!=0 && self.password.text.length!=0){
        self.loginBtn.enabled=YES;
    }
    // NSLog(@"%@  %zd",textField.text,textField.text.length);
    if(textField.text.length<=1){
        self.loginBtn.enabled=NO;
    }
    
    return YES;
}
#pragma mark 点击登陆的方法
-(void)loginClick
{
    NSString *uname=[self trim:self.username.text];
    NSString *pass=[self trim:self.password.text];
    //登陆的方法
//    UserOperation *user=[UserOperation shareduser];
//    user.uname=uname;
//    user.password=pass;
    BTXMPPTool *app=[BTXMPPTool sharedInstance];
    app.registerOperation=NO;  //注册的方法
    //把block转成弱应用
    __weak typeof(self) selfVc=self;
    // __weak typeof(self) selfVc=self;
    //显示旋转矿
    [self.view endEditing:YES];
    
    [app login:^(XMPPResultType xmppType) {
        [selfVc handle:xmppType];
        //NSLog(@"登录");
    }];
}
#pragma mark 用户登录验证的方法
-(void)handle:(XMPPResultType)xmppType {
    //回到主线程
    
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (xmppType) {
            case XMPPResultSuccess:
            {
//                [BaseMethod showSuccess:@"登录成功" toView:self.view];;
                [self enterHome];
            }
                break;
            case XMPPResultFaiture:
            {
//                [BaseMethod showError:@"用户名或密码错误" toView:self.view];
            }
                break;
            case XMPPResultNetworkErr:
            {
//                [BaseMethod showError:@"网络不给力" toView:self.view];
            }
                break;
        }
    });
    
}
#pragma mark 登录成功后进入主界面
-(void)enterHome
{
//    UserOperation *user=[UserOperation shareduser];
//    user.loginStatus=YES; //登录成功保存登录状态
    //清空输入框里面的文字
    self.username.text=nil;
    self.password.text=nil;
    
    [self dismissViewControllerAnimated:NO completion:nil];
    
//    MyTabBarController *tab=[[MyTabBarController alloc]init];
//    [self presentViewController:tab animated:NO completion:nil];
    
    
}
#pragma mark 注册按钮点击的方法
-(void)regisClick
{
//    RegisterController *reg=[[RegisterController alloc]init];
//    [self.navigationController pushViewController:reg animated:YES];
//    self.navigationItem.backBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
}

#pragma mark 截取字符串空格的方法
-(NSString*)trim:(NSString*)str
{
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [str lowercaseString]; //转成小写
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.enabled=NO;
        
        //PayCardLightGreenBG   fts_green_btn
        //    [_loginBtn setBackgroundImage:[UIImage resizedImage:@"fts_green_btn"] forState:UIControlStateNormal];
        //    [_loginBtn setBackgroundImage:[UIImage resizedImage:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
        //    [_loginBtn setBackgroundImage:[UIImage resizedImage:@"GreenBigBtnDisable"] forState:UIControlStateDisabled];
        [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        //    [btn setTitleColor:WColorAlpha(255, 255, 255, 0.5) forState:UIControlStateDisabled];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (BTTextField *)username {
    if (!_username) {
        _username = [[BTTextField alloc] init];
        _username.delegate=self;
        _username.image=@"biz_pc_main_info_profile_login_user_icon";
        _username.contentPlaceholder=@"请输入用户名";
    }
    return _username;
}

- (BTTextField *)password {
    if (!_password) {
        _password = [[BTTextField alloc] init];
        _password.secureTextEntry=YES;
        _password.delegate=self;
        _password.image=@"biz_pc_main_info_profile_login_pw_icon";
        _password.contentPlaceholder=@"请输入密码";
    }
    return _password;
}

@end
