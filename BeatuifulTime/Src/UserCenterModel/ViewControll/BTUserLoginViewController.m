//
//  BTUserLoginViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTUserLoginViewController.h"
#import "BTTextField.h"

#define commonMargin 20
#define marginX 20
#define textFieldWidth  (ScreenWidth-2*marginX)
#define textFieldHeight 30

@interface BTUserLoginViewController ()<UITextFieldDelegate>
//登陆按钮
@property (nonatomic,weak) UIButton *loginBtn;
@property (nonatomic,weak) BTTextField *username;
@property (nonatomic,weak) BTTextField *pass;

@end

@implementation BTUserLoginViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"登陆微信";
    [self setupChild];
    [self addGesture];
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

#pragma mark 添加子控件
- (void)setupChild {
    //1.添加输入用户名的框
    _username=[[BTTextField alloc]init];
    _username.delegate=self;
    _username.frame=CGRectMake(30, 50, 150, 50);
    _username.image=@"biz_pc_main_info_profile_login_user_icon";
    _username.contentPlaceholder=@"请输入用户名/手机号";
    [self.view addSubview:_username];    //2.添加下划线
    CGFloat oneLineY=commonMargin+textFieldHeight+10;
//    [self addbottomLineWith:CGRectMake(marginX, oneLineY, textFieldWidth, 0.5)];
    //3.添加密码输入框
    _pass = [[BTTextField alloc]init];
    _pass.secureTextEntry=YES;
    _pass.delegate=self;
    CGFloat passY=commonMargin+textFieldHeight+20;
    _pass.frame=CGRectMake(30, 100, 150, 50);
//    _pass.image=@"biz_pc_main_info_profile_login_pw_icon";
    _pass.contentPlaceholder=@"请输入密码";
    [self.view addSubview:_pass];
    //4.添加下划线
    CGFloat twoLineY=passY+textFieldHeight+10;
//    [self addbottomLineWith:CGRectMake(marginX, twoLineY, textFieldWidth, 0.5)];
    //5.添加登陆按钮
    CGFloat loginbtnY=twoLineY+20;
    [self addLoginButton:CGRectMake(30, 240, 150, 40)];
//    //6添加注册按钮
//    CGFloat regisW=40;
//    CGFloat regisH=30;
//    CGFloat regisX=(200-regisW)*0.5;
//    CGFloat regisY=self.view.height-64-regisH-10;
//    [self addRegisButton:CGRectMake(regisX, regisY, regisW, regisH)];
    
}
#pragma mark 添加下划线的方法
-(void)addbottomLineWith:(CGRect)bounds
{
    UIImageView *line=[[UIImageView alloc]initWithFrame:bounds];
    //line.width=0.5;
    line.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:line];
}
#pragma mark 添加登陆按钮
-(void)addLoginButton:(CGRect)bounds
{
    UIButton *btn=[[UIButton alloc]initWithFrame:bounds];
    self.loginBtn=btn;
    btn.enabled=NO;
    
    //PayCardLightGreenBG   fts_green_btn
//    [btn setBackgroundImage:[UIImage resizedImage:@"fts_green_btn"] forState:UIControlStateNormal];
//    [btn setBackgroundImage:[UIImage resizedImage:@"fts_green_btn_HL"] forState:UIControlStateHighlighted];
//    [btn setBackgroundImage:[UIImage resizedImage:@"GreenBigBtnDisable"] forState:UIControlStateDisabled];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [btn setTitleColor:WColorAlpha(255, 255, 255, 0.5) forState:UIControlStateDisabled];
    [btn setTitle:@"登陆" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    
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
    if(self.username.text.length!=0 && self.pass.text.length!=0){
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
    NSString *pass=[self trim:self.pass.text];
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
    self.pass.text=nil;
    
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
    // NSLog(@"%@",[str lowercaseString]);
    return [str lowercaseString]; //转成小写
}

-(void)dealloc
{
    NSLog(@"登录控制器消失了");
}

@end
