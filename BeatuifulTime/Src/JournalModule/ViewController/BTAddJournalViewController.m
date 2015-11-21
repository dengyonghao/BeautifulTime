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
@property (nonatomic, strong) UIScrollView *bodyScrollView;
@property (nonatomic, strong) UIButton *photos;
@property (nonatomic, strong) UIButton *site;
@property (nonatomic, strong) UIButton *weather;
@property (nonatomic, strong) UIButton *records;
@property (nonatomic, strong) UIButton *date;
@property (nonatomic, strong) UITextView *content;

@property (nonatomic, strong) UIButton *finshBnt;
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) UIButton *city;
@property (nonatomic, strong) UIButton *weath;
@property (nonatomic, strong) UIButton *phonos;
@property (nonatomic, strong) UIButton *record;

@property (nonatomic, strong) UIImagePickerController *picker;
@property(nonatomic,copy) NSString *chosenMediaType;


@end

@implementation BTAddJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记笔记";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.view addSubview:self.date];
    [self.bodyView addSubview:self.site];
    [self.bodyView addSubview:self.weather];
    [self.bodyView addSubview:self.photos];
    [self.bodyView addSubview:self.records];
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
    [self.date mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.site mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.weather mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.photos mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.records mas_makeConstraints:^(MASConstraintMaker *make) {
        
    }];
    
    [self.bodyScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.bodyView).offset(BUTTONWIDTH + OFFSET);
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
            
        }
    }];
    [self.locationManager stopUpdatingLocation];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)finishButtonClick {
    Journal *newJournal = [NSEntityDescription insertNewObjectForEntityForName:@"Journal" inManagedObjectContext:[AppDelegate getInstance].coreDataHelper.context];
    NSData* data = [self.content.text dataUsingEncoding:NSUTF8StringEncoding];
    newJournal.journalContent = data;
    [[AppDelegate getInstance].coreDataHelper saveContext];
}

- (void)selectPhotoSource{
    UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"请选择图片来源" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"拍照",@"从手机相册选择", nil];
    [alert show];
}

#pragma 拍照选择模块
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1)
        [self shootPiicturePrVideo];
    else if(buttonIndex==2)
        [self selectExistingPictureOrVideo];
}

#pragma  mark- 拍照模块
//从相机上选择
-(void)shootPiicturePrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypeCamera];
}
//从相册中选择
-(void)selectExistingPictureOrVideo{
    [self getMediaFromSource:UIImagePickerControllerSourceTypePhotoLibrary];
}

#pragma 拍照模块
-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    self.chosenMediaType=[info objectForKey:UIImagePickerControllerMediaType];
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeImage]){
        UIImage *chosenImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        
    }
    if([self.chosenMediaType isEqual:(NSString *) kUTTypeMovie]){
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"提示信息!" message:@"系统只支持图片格式" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
        
    }
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void) imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)getMediaFromSource:(UIImagePickerControllerSourceType)sourceType{
    NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
    if([UIImagePickerController isSourceTypeAvailable:sourceType] &&[mediatypes count]>0){
        NSArray *mediatypes = [UIImagePickerController availableMediaTypesForSourceType:sourceType];
        self.picker.mediaTypes = mediatypes;
        self.picker.sourceType = sourceType;
        NSString *requiredmediatype = (NSString *)kUTTypeImage;
        NSArray *arrmediatypes = [NSArray arrayWithObject:requiredmediatype];
        [self.picker setMediaTypes:arrmediatypes];
        [self presentViewController:self.picker animated:YES completion:^{
            
        }];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc] initWithTitle:@"错误信息!" message:@"当前设备不支持拍摄功能" delegate:nil cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [alert show];
    }
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
    }
    return _records;
}

- (UIButton *)date {
    if (!_date) {
        _date = [[UIButton alloc] init];
    }
    return _date;
}

- (UIImagePickerController *)picker {
    if (!_picker) {
        _picker = [[UIImagePickerController alloc] init];
        _picker.delegate = self;
    }
    return _picker;
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
