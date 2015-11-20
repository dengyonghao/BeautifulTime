//
//  BTUserLoginViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTUserLoginViewController.h"
#import "BTTextField.h"
#import "UIImage+Addition.h"
#import "BTContacterViewController.h"
#import "BTRegisterAccountViewController.h"

#define margin 20
#define textFieldHeight 30

@interface BTUserLoginViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *loginBtn;
@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) BTTextField *username;
@property (nonatomic,strong) BTTextField *password;

@end

@implementation BTUserLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"用户登陆";
    [self.bodyView addSubview:self.username];
    [self addbottomLineWith:CGRectMake(margin, 50 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.password];
    [self addbottomLineWith:CGRectMake(margin, 100 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.loginBtn];
    [self.bodyView addSubview:self.registerBtn];
    [self addGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(margin);
        make.left.equalTo(weakSelf.bodyView).offset(margin);
        make.right.equalTo(weakSelf.bodyView).offset(-margin);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.username).offset(margin + textFieldHeight);
        make.left.equalTo(weakSelf.username);
        make.right.equalTo(weakSelf.username);
        make.height.equalTo(@(textFieldHeight));
    }];
    [self.loginBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password).offset(30 + textFieldHeight);
        make.left.equalTo(weakSelf.password);
        make.right.equalTo(weakSelf.password);
        make.height.equalTo(@(40));
    }];
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.loginBtn).offset(margin + 40);
        make.left.equalTo(weakSelf.loginBtn);
        make.right.equalTo(weakSelf.loginBtn);
        make.height.equalTo(weakSelf.loginBtn);
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
-(void)tapClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark 添加下划线的方法
-(void)addbottomLineWith:(CGRect)bounds {
    UIImageView *line=[[UIImageView alloc]initWithFrame:bounds];
    line.backgroundColor=[[BTThemeManager getInstance] BTThemeColor:@"cl_line_a2_item"];
    [self.view addSubview:line];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.username.text.length != 0 && self.password.text.length != 0){
        self.loginBtn.enabled=YES;
    }
    if(textField.text.length <= 1) {
        self.loginBtn.enabled = NO;
    }
    
    return YES;
}

#pragma mark 点击登陆的方法
-(void)registerClick {
    BTRegisterAccountViewController *vc = [[BTRegisterAccountViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 点击登陆的方法
-(void)loginClick
{
//    NSString *uname=[self trim:self.username.text];
//    NSString *pass=[self trim:self.password.text];
    //登陆的方法
//    UserOperation *user=[UserOperation shareduser];
//    user.uname=uname;
//    user.password=pass;
    BTXMPPTool *xmppTool=[BTXMPPTool sharedInstance];
    xmppTool.registerOperation=NO;  //注册的方法
    
    WS(weakSelf);
    
    //显示旋转矿
    [self.view endEditing:YES];
    
    [xmppTool login:^(XMPPResultType xmppType) {
        [weakSelf handle:xmppType];
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
    BTContacterViewController *vc = [[BTContacterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:NO];

    
    
}

#pragma mark 截取字符串空格的方法
-(NSString*)trim:(NSString*)str {
    str=[str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    return [str lowercaseString]; //转成小写
}

- (UIButton *)loginBtn {
    if (!_loginBtn) {
        _loginBtn = [[UIButton alloc] init];
        _loginBtn.enabled=NO;
        [_loginBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateNormal];
        [_loginBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateHighlighted];
        [_loginBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateDisabled];
        [_loginBtn setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_content"] forState:UIControlStateNormal];
        [_loginBtn setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginBtn.layer setMasksToBounds:YES];
        [_loginBtn.layer setCornerRadius:5.0];
        [_loginBtn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginBtn;
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        [_registerBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_b"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_b"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateHighlighted];
        [_registerBtn setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_content"] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册账号" forState:UIControlStateNormal];
        [_registerBtn.layer setMasksToBounds:YES];
        [_registerBtn.layer setCornerRadius:5.0];
        [_registerBtn addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerBtn;
}


- (BTTextField *)username {
    if (!_username) {
        _username = [[BTTextField alloc] init];
        _username.delegate=self;
        _username.image=@"bt_login_user_icon";
        _username.contentPlaceholder=@"请输入用户名";
    }
    return _username;
}

- (BTTextField *)password {
    if (!_password) {
        _password = [[BTTextField alloc] init];
        _password.secureTextEntry=YES;
        _password.delegate=self;
        _password.image=@"bt_login_pw_icon";
        _password.contentPlaceholder=@"请输入密码";
    }
    return _password;
}

@end