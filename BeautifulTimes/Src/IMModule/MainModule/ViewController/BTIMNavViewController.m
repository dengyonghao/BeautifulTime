//
//  BTIMNavViewController.m
//  BeautifulTimes
//
//  Created by dengyonghao on 16/1/7.
//  Copyright © 2016年 dengyonghao. All rights reserved.
//

#import "BTIMNavViewController.h"

@interface BTIMNavViewController ()

@end

@implementation BTIMNavViewController

+(void)initialize
{
    UINavigationBar *navBar=[UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage resizedImage:@"topbarbg_ios7"] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:[UIColor whiteColor]];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    navBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
    //2.设置导航栏barButton上面文字的颜色
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTintColor:[UIColor whiteColor]];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

#pragma mark 当push的时候调用这个方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count>0){
        viewController.hidesBottomBarWhenPushed=YES; //当push 的时候隐藏底部兰
    }
    [super pushViewController:viewController animated:animated];
    
}

//返回白色的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
