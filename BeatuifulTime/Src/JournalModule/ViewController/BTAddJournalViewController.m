//
//  BTAddJournalViewController.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/10/21.
//  Copyright (c) 2015年 dengyonghao. All rights reserved.
//

#import "BTAddJournalViewController.h"
#import "AppDelegate.h"
#import <CoreLocation/CoreLocation.h>
#import "Journal.h"
#import "BTNetManager+BTAddJournal.h"
#import "BTRecordViewController.h"
#import "BTJournalController.h"
#import "BTWeatherModel.h"

@interface BTAddJournalViewController ()<UITextViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *site;
@property (nonatomic, strong) UIButton *weather;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UIButton *date;
@property (nonatomic, strong) UITextView *content;

@property (nonatomic, strong) UIButton *finshBnt;
@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation BTAddJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记笔记";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.toolsView];
    [self.toolsView addSubview:self.date];
    [self.toolsView addSubview:self.site];
    [self.toolsView addSubview:self.weather];
    [self.toolsView addSubview:self.photos];
    [self.toolsView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
    [self startLocation];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat OFFSET = 10.0f;
    CGFloat BUTTONWIDTH = (BT_SCREEN_WIDTH - 2 * OFFSET) / 4;
    
    WS(weakSelf);
    
    [self.toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(5);
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@((BT_SCREEN_WIDTH - 20) / 4));
    }];
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.site mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.toolsView).offset(10);
        make.top.equalTo(weakSelf.toolsView).offset(10);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakSelf.toolsView);
        make.centerX.equalTo(weakSelf.toolsView);
        make.width.equalTo(@(60));
        make.height.equalTo(@(40));
    }];
    
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(BUTTONWIDTH + OFFSET);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
    
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(BUTTONWIDTH + OFFSET);
        make.left.equalTo(weakSelf.bodyView).offset(OFFSET);
        make.right.equalTo(weakSelf.bodyView).offset(-OFFSET);
        make.bottom.equalTo(weakSelf.bodyView).offset(-OFFSET);
    }];
}

//开始定位
-(void)startLocation{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    [self.locationManager startUpdatingLocation];
    
}

//检测是否支持定位
- (void)locationManager: (CLLocationManager *)manager
       didFailWithError: (NSError *)error {
    
    NSString *errorString;
    [manager stopUpdatingLocation];
    switch([error code]) {
        case kCLErrorDenied:
            errorString = @"用户拒绝访问位置服务";
            break;
        case kCLErrorLocationUnknown:
            errorString = @"位置数据不可用";
            break;
        default:
            errorString = @"发生未知错误";
            break;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
//    [alert show];
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    NSLog(@"%@",[NSString stringWithFormat:@"经度:%3.5f\n纬度:%3.5f",newLocation.coordinate.latitude,newLocation.coordinate.longitude]);
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *info = [placemark addressDictionary];
            NSString * city = [info objectForKey:@"City"];
            [self.site setTitle:city forState:UIControlStateNormal];
            [BTNetManager netManagerReqeustWeatherInfo:[self cutStr:city] successCallback:^(NSDictionary *retDict) {
                BTWeatherModel *model = [[BTWeatherModel alloc] init];
                model.city = retDict[@"HeWeather data service 3.0"][0][@"basic"][@"city"];
                model.pm25 = retDict[@"HeWeather data service 3.0"][0][@"aqi"][@"city"][@"pm25"];
                model.updateTime = retDict[@"HeWeather data service 3.0"][0][@"basic"][@"update"][@"loc"];
                model.maxTemperature = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"max"];
                model.minTemperature = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"min"];
                model.dayWeatherIcon = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_d"];
                model.nightWeatherIcon = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_n"];
                
//                NSLog(@"-----------%@",retDict);
//                NSLog(@"-----1pm25------%@",retDict[@"HeWeather data service 3.0"][0][@"aqi"][@"city"][@"pm25"]);
//                NSLog(@"-----2ciyt------%@",retDict[@"HeWeather data service 3.0"][0][@"basic"][@"city"]);
//                NSLog(@"-----3updateTime------%@",retDict[@"HeWeather data service 3.0"][0][@"basic"][@"update"][@"loc"]);
//                NSLog(@"-----4day------%@",retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_d"]);
//                NSLog(@"-----5night------%@",retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_n"]);
//                NSLog(@"-----6maxTmp------%@",retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"max"]);
//                NSLog(@"-----7minTmp------%@",retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"min"]);
                
            } failCallback:^(NSError *error) {
                
            }];
        }
    }];
    [self.locationManager stopUpdatingLocation];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)getCurrentDate {
    NSDate *currentDate = [NSDate date];
    NSDateFormatter *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"YYYY-MM-dd"];
    NSString *currentDateString = [dateformatter stringFromDate:currentDate];
    return currentDateString;
}

- (void)finishButtonClick {
    Journal *newJournal = [NSEntityDescription insertNewObjectForEntityForName:@"Journal" inManagedObjectContext:[AppDelegate getInstance].coreDataHelper.context];
    NSData* data = [self.content.text dataUsingEncoding:NSUTF8StringEncoding];
    newJournal.journalContent = data;
    newJournal.journalDate = [NSDate date];
    newJournal.site = self.site.titleLabel.text;
    newJournal.records = [BTJournalController sharedInstance].record;
    [[AppDelegate getInstance].coreDataHelper saveContext];
}

- (void)recordsClick {
    BTRecordViewController *vc = [[BTRecordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark 去掉市字
-(NSString*)cutStr:(NSString*)str {
    NSArray *arr = [str componentsSeparatedByString:@"市"];
    return arr[0];
}


- (UIView *)toolsView {
    if (!_toolsView) {
        _toolsView = [[UIView alloc] init];
        _toolsView.backgroundColor = [UIColor greenColor];
    }
    return _toolsView;
}

- (UIScrollView *)bodyScrollView {
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] init];
        _bodyScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH - 20, BT_SCREEN_HEIGHT);
    }
    return _bodyScrollView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.delegate = self;
    }
    return _content;
}

- (UIButton *)photos {
    if (!_photos) {
        _photos = [[UIButton alloc] init];
    }
    return _photos;
}

- (UIButton *)site {
    if (!_site) {
        _site = [[UIButton alloc] init];
    }
    return _site;
}

- (UIButton *)weather {
    if (!_weather) {
        _weather = [[UIButton alloc] init];
    }
    return _weather;
}

- (UIButton *)records {
    if (!_records) {
        _records = [[UIButton alloc] init];
        [_records setTitle:@"录音" forState:UIControlStateNormal];
        [_records addTarget:self action:@selector(recordsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _records;
}

- (UIButton *)date {
    if (!_date) {
        _date = [[UIButton alloc] init];
    }
    return _date;
}


@end
