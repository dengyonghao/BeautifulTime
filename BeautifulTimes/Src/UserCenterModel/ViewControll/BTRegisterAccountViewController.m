//
//  BTRegisterAccountViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTRegisterAccountViewController.h"
#import "BTTextField.h"
#import "UIImage+Addition.h"
#import "MBProgressHUD+MJ.h"
#import "BTIMTabBarController.h"
#import "AppDelegate.h"

#define margin 20
#define textFieldHeight 30

@interface BTRegisterAccountViewController ()<UITextFieldDelegate>

@property (nonatomic,strong) UIButton *registerBtn;
@property (nonatomic,strong) BTTextField *username;
@property (nonatomic,strong) BTTextField *password;

@end

@implementation BTRegisterAccountViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"用户注册";
    [self.bodyView addSubview:self.username];
    [self addbottomLineWith:CGRectMake(margin, 50 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
    [self.bodyView addSubview:self.password];
    [self addbottomLineWith:CGRectMake(margin, 100 + self.headerView.frame.size.height + 5, BT_SCREEN_WIDTH -2 * margin, 0.5)];
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
    [self.registerBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password).offset(30 + textFieldHeight);
        make.left.equalTo(weakSelf.password);
        make.right.equalTo(weakSelf.password);
        make.height.equalTo(@(40));
    }];
}

#pragma mark 添加手势识别器
- (void)addGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapClick:)];
    tap.numberOfTapsRequired=1;
    [self.view addGestureRecognizer:tap];
}
#pragma mark 点击的方法
- (void)tapClick:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark 添加下划线的方法
- (void)addbottomLineWith:(CGRect)bounds {
    UIImageView *line=[[UIImageView alloc]initWithFrame:bounds];
    line.backgroundColor = [UIColor grayColor];
    [self.view addSubview:line];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(self.username.text.length != 0 && self.password.text.length != 0){
        self.registerBtn.enabled=YES;
    }
    if(textField.text.length <= 1) {
        self.registerBtn.enabled = NO;
    }
    return YES;
}

#pragma mark 点击注册的方法
- (void)registerClick {
    
    NSString *userName = [self.username.text trim];
    NSString *password = [self.password.text trim];
    
    [[NSUserDefaults standardUserDefaults] setValue:userName forKey:userID];
    [[NSUserDefaults standardUserDefaults] setValue:password forKey:userPassword];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    BTXMPPTool *xmppTool = [BTXMPPTool sharedInstance];
    xmppTool.registerOperation = YES;
    [self.view endEditing:YES];
    WS(weakSelf);
    [xmppTool regist:^(XMPPResultType xmppType) {
        //不管成功或者失败，都要把registerOperation设为NO， 要不成功时登录将会失败
        xmppTool.registerOperation = NO;
        [weakSelf handle:xmppType];
    }];
}

#pragma mark 用户注册验证的方法
- (void)handle:(XMPPResultType)xmppType {
    [MBProgressHUD hideHUDForView:self.view];
    dispatch_async(dispatch_get_main_queue(), ^{
        switch (xmppType) {
            case XMPPResultSuccess:
                [MBProgressHUD showSuccess:@"登录成功" toView:self.view];
                break;
            case XMPPResultFaiture:
                [MBProgressHUD showError:@"用户名或密码错误" toView:self.view];
                break;
            case XMPPResultNetworkErr:
                [MBProgressHUD showError:@"网络不给力" toView:self.view];
                break;
            case XMPPResultRegisterSuccess:
                [MBProgressHUD showError:@"注册成功" toView:self.view];
                [self enterHome];
                break;
            case XMPPResultRegisterFailture:
                [MBProgressHUD showError:@"注册失败,用户名重复。" toView:self.view];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userID];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userPassword];
                [[NSUserDefaults standardUserDefaults] synchronize];
                break;
        }
    });
}

#pragma mark 注册成功后进入主界面
-(void)enterHome
{
    if ([[NSUserDefaults standardUserDefaults] valueForKey:userID] && [[NSUserDefaults standardUserDefaults] valueForKey:userPassword]) {
        WS(weakSelf);
        [[BTXMPPTool sharedInstance] login:^(XMPPResultType xmppType) {
            if (xmppType == XMPPResultSuccess) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    BTIMTabBarController *tab = [[BTIMTabBarController alloc]init];
                    [AppDelegate getInstance].window.rootViewController = tab;
                    
                    //设置默认头像
                    BTXMPPTool *tool = [BTXMPPTool sharedInstance];
                    XMPPvCardTemp *temp = tool.vCard.myvCardTemp;
                    NSData *imagedata = UIImagePNGRepresentation(BT_LOADIMAGE(@"com_ic_defaultIcon"));
                    temp.photo = imagedata;
                    [tool.vCard updateMyvCardTemp:temp];
                });
                
            } else {
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userID];
                [[NSUserDefaults standardUserDefaults] setValue:nil forKey:userPassword];
                
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"自动登录失败，请重新登录。" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            }
        }];
    }
}

- (UIButton *)registerBtn {
    if (!_registerBtn) {
        _registerBtn = [[UIButton alloc] init];
        _registerBtn.enabled=NO;
        [_registerBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_btn_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateNormal];
        [_registerBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateHighlighted];
        [_registerBtn setBackgroundImage:[UIImage createImageWithColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_press_d"] andSize:CGSizeMake(BT_SCREEN_WIDTH - 2 * margin, textFieldHeight)] forState:UIControlStateDisabled];
        [_registerBtn setTitleColor:[[BTThemeManager getInstance] BTThemeColor:@"cl_text_a4_content"] forState:UIControlStateNormal];
        [_registerBtn setTitle:@"注册" forState:UIControlStateNormal];
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
        _username.image = @"bt_login_user_icon";
        _username.contentPlaceholder = @"请输入用户名";
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
