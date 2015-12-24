//
//  BTAddJournalViewController.m
//  BeautifulTimes
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
#import "BTCalendarView.h"
#import "BTWeatherStatusVeiw.h"
#import "BTHomePageViewController.h"
#import "UIView+BTAddition.h"
#import "BTMyAlbumViewController.h"

static const CGFloat itemWidth = 70;

@interface BTAddJournalViewController ()<UITextViewDelegate, CLLocationManagerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) UIView *toolsView;
@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) BTWeatherStatusVeiw *weatherStatusView;
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIImageView *photos;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UITextView *content;
@property (nonatomic, strong) BTWeatherModel *model;

@end

@implementation BTAddJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记笔记";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.toolsView];
    [self.toolsView addSubview:self.calendarView];
    [self.toolsView addSubview:self.weatherStatusView];
    [self.toolsView addSubview:self.photos];
    [self.toolsView addSubview:self.records];
    [self.bodyView addSubview:self.bodyScrollView];
    [self.bodyScrollView addSubview:self.content];
    [self startLocation];
    [self addImageViewGesture];
}

#pragma mark 添加手势识别器
-(void)addImageViewGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(photosClick)];
    tap.numberOfTapsRequired=1;
    [self.photos addGestureRecognizer:tap];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat OFFSET = 10.0f;
    CGFloat BUTTONWIDTH = (BT_SCREEN_WIDTH - 2 * OFFSET) / 4;
    
    WS(weakSelf);
    
    [self.toolsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView);
        make.left.equalTo(weakSelf.bodyView).offset(10);
        make.right.equalTo(weakSelf.bodyView).offset(-10);
        make.height.equalTo(@(80));
    }];
    CGFloat offset = (BT_SCREEN_WIDTH - 20 - itemWidth * 4) / 5;
    [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.toolsView).offset(offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    [self.weatherStatusView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.calendarView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.weatherStatusView).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
    }];
    
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.toolsView).offset(5);
        make.left.equalTo(weakSelf.photos).offset(itemWidth + offset);
        make.width.equalTo(@(itemWidth));
        make.height.equalTo(@(itemWidth));
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
            [BTNetManager netManagerReqeustWeatherInfo:[self cutStr:city] successCallback:^(NSDictionary *retDict) {
                self.model.city = retDict[@"HeWeather data service 3.0"][0][@"basic"][@"city"];
                self.model.pm25 = retDict[@"HeWeather data service 3.0"][0][@"aqi"][@"city"][@"pm25"];
                self.model.updateTime = retDict[@"HeWeather data service 3.0"][0][@"basic"][@"update"][@"loc"];
                self.model.maxTemperature = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"max"];
                self.model.minTemperature = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"tmp"][@"min"];
                self.model.dayWeatherIcon = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_d"];
                self.model.nightWeatherIcon = retDict[@"HeWeather data service 3.0"][0][@"daily_forecast"][0][@"cond"][@"txt_n"];
                [self.weatherStatusView bindData:self.model];
                
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
    newJournal.site = self.model.city;
    NSData *photosData = [NSKeyedArchiver archivedDataWithRootObject:[BTJournalController sharedInstance].photos];
    newJournal.photos = photosData;
    newJournal.records = [BTJournalController sharedInstance].record;
    [[AppDelegate getInstance].coreDataHelper saveContext];
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTHomePageViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }

}

- (void)photosClick {
    BTMyAlbumViewController *vc = [[BTMyAlbumViewController alloc] init];
    vc.isSelectModel = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
        _toolsView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_press_e"] ;
        [_toolsView setBorderWithWidth:1 color:nil cornerRadius:8];
    }
    return _toolsView;
}

- (BTCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[BTCalendarView alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
        NSDate *date = [NSDate date];
        [_calendarView bindData:date];
    }
    return _calendarView;
}

- (BTWeatherStatusVeiw *)weatherStatusView {
    if (!_weatherStatusView) {
        _weatherStatusView = [[BTWeatherStatusVeiw alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemWidth)];
    }
    return _weatherStatusView;
}

- (UIScrollView *)bodyScrollView {
    if (!_bodyScrollView) {
        _bodyScrollView = [[UIScrollView alloc] init];
        _bodyScrollView.contentSize = CGSizeMake(BT_SCREEN_WIDTH - 20, BT_SCREEN_HEIGHT);
        [_content setBorderWithWidth:1 color:nil cornerRadius:6];
    }
    return _bodyScrollView;
}

- (UITextView *)content {
    if (!_content) {
        _content = [[UITextView alloc] init];
        _content.delegate = self;
        [_content setBorderWithWidth:1 color:nil cornerRadius:6];
    }
    return _content;
}

- (UIImageView *)photos {
    if (!_photos) {
        _photos = [[UIImageView alloc] init];
        [_photos setImage:BT_LOADIMAGE(@"com_ic_photo")];
        [_photos setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        _photos.userInteractionEnabled = YES;
    }
    return _photos;
}

- (UIButton *)records {
    if (!_records) {
        _records = [[UIButton alloc] init];
        [_records setBorderWithWidth:1 color:[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] cornerRadius:5];
        [_records setImage:BT_LOADIMAGE(@"com_ic_voice") forState:UIControlStateNormal];
        [_records addTarget:self action:@selector(recordsClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _records;
}

- (BTWeatherModel *)model {
    if (!_model) {
        _model = [[BTWeatherModel alloc] init];
    }
    return _model;
}

@end
