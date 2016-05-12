//
//  BTAddTimelineViewController.m
//  BeautifulTimes
//
//  Created by deng on 15/12/6.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTAddTimelineViewController.h"
#import "BTAddressBookViewController.h"
#import "BTTimelineToolView.h"
#import "BTTimelineModel.h"
#import "BTTimelineDBManager.h"
#import "BTHomePageViewController.h"
#import "BTSelectPhotosViewController.h"
#import "BTAddressBookViewController.h"
#import "BTJournalController.h"

@interface BTAddTimelineViewController () <BTTimelineToolViewDelegate, CLLocationManagerDelegate>

@property (nonatomic, strong) BTTimelineToolView *toolView;
@property (nonatomic, strong) UITextView *contentTextView;
@property (nonatomic, strong) UILabel *site;
@property (nonatomic, strong) CLLocationManager* locationManager;

@end

@implementation BTAddTimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"记点滴";
    [self.finishButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.bodyView addSubview:self.toolView];
    [self.bodyView addSubview:self.contentTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void)viewDidLayoutSubviews {
    WS(weakSelf);
    [self.toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(weakSelf.bodyView);
        make.right.equalTo(weakSelf.bodyView);
        make.height.equalTo(@(48));
        make.bottom.equalTo(weakSelf.bodyView);
    }];
    
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.bodyView).insets(UIEdgeInsetsMake(0, 0, 48, 0));
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - click event
- (void)backButtonClick {
    [[BTJournalController sharedInstance] resetAllParameters];
    [super backButtonClick];
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
}

//定位代理经纬度回调
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    CLGeocoder * geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *placemarks, NSError *error) {
        for (CLPlacemark * placemark in placemarks) {
            NSDictionary *info = [placemark addressDictionary];
            NSString *city = [info objectForKey:@"City"];
            NSString *country = [info objectForKey:@"Country"];
            self.site.text = [NSString stringWithFormat:@"%@%@", country, city];
        }
    }];
    [self.locationManager stopUpdatingLocation];
}

#pragma timelineToolView delegate
- (void)timelineToolViewDidSelectAtCurrentSite {
    [self startLocation];
}

- (void)timelineToolViewDidSelectAtSelectPhotos {
    [self.contentTextView resignFirstResponder];
    BTSelectPhotosViewController *vc = [[BTSelectPhotosViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)timelineToolViewDidSelectAtAddressBook {
    [self.contentTextView resignFirstResponder];
    BTAddressBookViewController *vc = [[BTAddressBookViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark keyboard delegate
- (void) keyboardWasShown:(NSNotification *) notif{
    
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{

    [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48 - keyboardSize.height)];
    [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48 - keyboardSize.height, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}

- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.bodyView.frame.size.height - 48)];
        [self.toolView setFrame:CGRectMake(0, self.bodyView.frame.size.height - 48, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
}


- (void)keyboardWillChangeFrame:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGFloat duration = [[info objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect beginKeyboardRect = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endKeyboardRect = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    CGFloat yOffset = endKeyboardRect.origin.y - beginKeyboardRect.origin.y;
    
    [UIView animateWithDuration:duration animations:^{
        [self.contentTextView setFrame:CGRectMake(0, self.contentTextView.frame.origin.y, self.contentTextView.frame.size.width, self.contentTextView.frame.size.height  + yOffset)];
        [self.toolView setFrame:CGRectMake(0, self.toolView.frame.origin.y + yOffset, self.toolView.frame.size.width, self.toolView.frame.size.height)];
    }];
    
}


- (void)finishButtonClick {
    BTTimelineModel *model = [[BTTimelineModel alloc] init];
    model.timelineContent = [self.contentTextView.text dataUsingEncoding:NSUTF8StringEncoding];
    if (self.site.text) {
        model.site = self.site.text;
    }
    model.timelineDate = [NSDate date];
    [[BTTimelineDBManager sharedInstance] addTimelineMessage:model];
    
    NSData *photosData = [NSKeyedArchiver archivedDataWithRootObject:[BTJournalController sharedInstance].photos];
    NSString *documentDirectory = [BTTool getDocumentDirectory];
    //唯一标识的id
    NSString *uid = [self getSaveFilePath];
    NSString *savePath = [documentDirectory stringByAppendingPathComponent:uid];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    while (true) {
        if (![fileManager fileExistsAtPath:savePath]) {
            break;
        } else {
            uid = [self getSaveFilePath];
            savePath = [documentDirectory stringByAppendingPathComponent:uid];
        }
    }
    [photosData writeToFile:savePath atomically:YES];
    
    model.photos = uid;
    
    for (UIViewController *controller in self.navigationController.viewControllers) {
        if ([controller isKindOfClass:[BTHomePageViewController class]]) {
            [self.navigationController popToViewController:controller animated:YES];
        }
    }
}

- (NSString *)getSaveFilePath {
    NSString *uid = [[NSUUID UUID] UUIDString];
    return uid;
}

- (BTTimelineToolView *)toolView {
    if (!_toolView) {
        _toolView = [[BTTimelineToolView alloc] init];
        _toolView.delegate = self;
    }
    return _toolView;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        _contentTextView = [[UITextView alloc] init];
    }
    return _contentTextView;
}

- (UILabel *)site {
    if (!_site) {
        _site = [[UILabel alloc] init];
    }
    return _site;
}

@end
