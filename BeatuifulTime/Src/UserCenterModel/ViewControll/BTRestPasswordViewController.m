//
//  BTRestPasswordViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/18.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTRestPasswordViewController.h"

@interface BTRestPasswordViewController ()

@property (nonatomic, strong) UITextField *oldPassword;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITextField *confirmPassword;
@property (nonatomic, strong) UIButton *confirm;

@end

@implementation BTRestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"修改密码";
    [self.view addSubview:self.oldPassword];
    [self.view addSubview:self.password];
    [self.view addSubview:self.confirmPassword];
    [self.view addSubview:self.confirm];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    WS(weakSelf);
    [self.oldPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(50);
        make.left.equalTo(weakSelf.view).offset(30);
        make.right.equalTo(weakSelf.view).offset(-30);
        make.height.equalTo(@(30));
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.oldPassword).offset(50);
        make.left.equalTo(weakSelf.oldPassword);
        make.right.equalTo(weakSelf.oldPassword);
        make.height.equalTo(weakSelf.oldPassword);

    }];
    [self.confirmPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.password).offset(50);
        make.left.equalTo(weakSelf.oldPassword);
        make.right.equalTo(weakSelf.oldPassword);
        make.height.equalTo(weakSelf.oldPassword);

    }];
    [self.confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.confirmPassword).offset(60);
        make.left.equalTo(weakSelf.oldPassword);
        make.right.equalTo(weakSelf.oldPassword);
        make.height.equalTo(@(44));
    }];
}

- (UITextField *)oldPassword {
    if (!_oldPassword) {
        _oldPassword = [[UITextField alloc] init];
        _confirmPassword.placeholder = @"旧密码";
        _oldPassword.layer.borderColor = UIColor.grayColor.CGColor;
        _oldPassword.layer.borderWidth = 1;
        _oldPassword.layer.cornerRadius = 6;
    }
    return _oldPassword;
}

- (UITextField *)password {
    if (!_password) {
        _password = [[UITextField alloc] init];
        _confirmPassword.placeholder = @"新密码";
        _password.layer.borderColor = UIColor.grayColor.CGColor;
        _password.layer.borderWidth = 1;
        _password.layer.cornerRadius = 6;
    }
    return _password;
}

- (UITextField *)confirmPassword {
    if (!_confirmPassword) {
        _confirmPassword = [[UITextField alloc] init];
        _confirmPassword.placeholder = @"确认密码";
        _confirmPassword.layer.borderColor = UIColor.grayColor.CGColor;
        _confirmPassword.layer.borderWidth = 1;
        _confirmPassword.layer.cornerRadius = 6;
    }
    return _confirmPassword;
}

-(UIButton *)confirm {
    if (!_confirm) {
        _confirm = [[UIButton alloc] init];
        [_confirm setTitle:@"确认修改" forState:UIControlStateNormal];
        _confirm.layer.borderColor = UIColor.grayColor.CGColor;
        _confirm.layer.borderWidth = 1;
        _confirm.layer.cornerRadius = 6;
    }
    return _confirm;
}

@end
