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
#import "BTNetManager.h"
#import "BTRecordViewController.h"
#import "BTJournalController.h"

//#define WEATHERINFO_HOST @"http://api.map.baidu.com"
//
//#define API_PATH_WEATHER @"/telematics/v3/weather"
//
//#define API_AK @"xfkg5isLkdyXDGAPYezFjtpb"
//
//#define DATA_TYPE @"json"

#define WEATHERINFO_HOST @"http://app.navi.baidu.com"

#define API_PATH_WEATHER @"/weather/get"


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
    NSLog(@"----------%@",[@"深圳" stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
    [self startLocation];
    
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
    //    [infoDic setObject:API_AK forKey:@"ak"];
    //    [infoDic setObject:DATA_TYPE forKey:@"output"];
    //    [infoDic setObject:cityName forKey:@"location"];
    
    [infoDic setObject:@"340" forKey:@"cityID"];
    [infoDic setObject:@"-1" forKey:@"bduss"];
    [infoDic setObject:@"" forKey:@"sign"];
    [infoDic setObject:@"" forKey:@"cuid"];
    [self requestWithHost:@"http://app.navi.baidu.com/weather/get" Path:@"http://app.navi.baidu.com/weather/get" params:infoDic fileParams:nil method:@"POST" ssl:NO forceReload:NO completion:^(NSDictionary *result, NSError *error) {
        NSLog(@"%@",result);
    }];
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
    [alert show];
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

- (AFHTTPRequestOperation *) netManagerReqeustWeatherInfo:(NSString *)cityName
                                          successCallback:(DictionaryResponseBlock)successCallback
                                             failCallback:(errorBlock)failCallback
{
    NSMutableDictionary *infoDic = [[NSMutableDictionary alloc] init];
    
//    [infoDic setObject:API_AK forKey:@"ak"];
//    [infoDic setObject:DATA_TYPE forKey:@"output"];
//    [infoDic setObject:cityName forKey:@"location"];
    
    [infoDic setObject:@"340" forKey:@"cityID"];
    [infoDic setObject:@"-1" forKey:@"bduss"];
    [infoDic setObject:@"f7fcbb889119780976e36c350b359d64" forKey:@"sign"];
    [infoDic setObject:@"68e1c869b8f55d806dc2112d7c352ca2" forKey:@"cuid"];
    
    AFHTTPRequestOperationManager *manager= [self configureAFHTTPRequestManagerWithURL:WEATHERINFO_HOST];
    AFHTTPRequestOperation *operation = [manager GET:API_PATH_WEATHER parameters:infoDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *result =  (NSDictionary*)responseObject;
        successCallback(result);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failCallback(error);
    }];
    return operation;
}

- (AFHTTPRequestOperationManager *)configureAFHTTPRequestManagerWithURL:(NSString *)url
{
    AFHTTPRequestOperationManager* manager = nil;
    
    if ([url isKindOfClass:[NSURL class]]) {
        // check NSURL 和 NSString
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:(NSURL *)url];
    }
    else {
        manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:url]];
    }
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    return manager;
}

- (void)requestWithHost:(NSString *)host
                   Path:(NSString *)path
                 params:(NSDictionary *)params
             fileParams:(NSDictionary *)fileParams
                 method:(NSString *)method
                    ssl:(BOOL)useSSL
            forceReload:(BOOL)forceReload
             completion:(void (^)(NSDictionary *result, NSError *error))completion
{
    if (!host) {
        completion(nil, [NSError errorWithDomain:@"" code:101 userInfo:@{@"description":@"参数错误"}]);
        return;
    }
    NSString* adHost = nil;
    if ([host rangeOfString:@"http://"].location == NSNotFound)
        adHost = [NSString stringWithFormat:@"http://%@",host];
    else
        adHost = host;
    
    AFHTTPRequestOperationManager* manager= [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:adHost]];
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    
    if ([method isEqualToString:@"POST"]){
        
        [manager POST:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSDictionary *result =  (NSDictionary*)responseObject;
            if (result != nil) {
                completion(result, nil);
            }
            else if (operation.response.statusCode >= 200 && operation.response.statusCode < 300) {
                
                NSDictionary *nojsonSuccess = [NSDictionary dictionaryWithObject:@(operation.response.statusCode) forKey:@"httpStatusCode"];
                completion(nojsonSuccess, nil);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"" code:100 userInfo:@{@"description":@"json解析错误"}];
                completion(nil, error);
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(nil, error);
        }];
    }
    
    if ([method isEqualToString:@"GET"])
    {
        [manager GET:path parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSDictionary *result =  (NSDictionary*)responseObject;
            if (result != nil) {
                completion(result, nil);
            }
            else if (operation.response.statusCode >= 200 && operation.response.statusCode < 300) {
                
                NSDictionary *nojsonSuccess = [NSDictionary dictionaryWithObject:@(operation.response.statusCode) forKey:@"httpStatusCode"];
                completion(nojsonSuccess, nil);
            }
            else
            {
                NSError *error = [NSError errorWithDomain:@"" code:100 userInfo:@{@"description":@"json解析错误"}];
                completion(nil, error);
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            completion(nil, error);
        }];
    }
}

@end
