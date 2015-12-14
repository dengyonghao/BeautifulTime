//
//  BTWeatherStatusVeiw.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTWeatherStatusVeiw.h"

@interface BTWeatherStatusVeiw ()

@property (nonatomic, strong) UIView *titleView;
@property (nonatomic, strong) UILabel     *cityName;    //城市名
@property (nonatomic, strong) UIImageView *weatherIcon; //天气icon
@property (nonatomic, strong) UILabel     *weatherInfo; //天气温度
@property (nonatomic, strong) UILabel     *pm25Label;   //pm2.5
@property (nonatomic, strong) UIImageView *pm25ImageView;

@end

@implementation BTWeatherStatusVeiw

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.titleView];
        [self.titleView addSubview:self.cityName];
        [self addSubview:self.weatherIcon];
        [self addSubview:self.weatherInfo];
        [self addSubview:self.pm25ImageView];
        [self addSubview:self.pm25Label];
        
        WS(weakSelf);
        [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf).insets(UIEdgeInsetsMake(0, 0, frame.size.height / 4 * 3, 0));
        }];
        [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(weakSelf.titleView).insets(UIEdgeInsetsMake(0, 0, 0, 0));
        }];
        [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.titleView).offset(frame.size.height / 4 + (frame.size.height / 4 * 3 / 2 - 32) / 2);
            make.left.equalTo(weakSelf).offset(10);
            make.width.equalTo(@(32));
            make.height.equalTo(@(32));
        }];
        [self.weatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.weatherIcon);
            make.left.equalTo(weakSelf.weatherIcon).offset(10 + 32 + 5);
            make.right.equalTo(weakSelf).offset(-10);
            make.height.equalTo(weakSelf.weatherIcon);
        }];
        [self.pm25ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.weatherIcon).offset(frame.size.height / 4 * 3 / 2 + (frame.size.height / 4 * 3 / 2 - 32) / 2);
            make.left.equalTo(weakSelf).offset(10);
            make.width.equalTo(@(32));
            make.height.equalTo(@(32));
        }];
        
        [self.pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf.pm25ImageView);
            make.left.equalTo(weakSelf.pm25ImageView).offset(10 + 32 + 5);
            make.right.equalTo(weakSelf).offset(-10);
            make.height.equalTo(weakSelf.pm25ImageView);
        }];

        CALayer *layer = [self layer];
        layer.borderColor = [[[BTThemeManager getInstance] BTThemeColor:@"cl_line_b_leftbar"] CGColor];
        layer.borderWidth = 1.0f;
        [layer setMasksToBounds:YES];
        [layer setCornerRadius:4.0];
        self.backgroundColor = [UIColor whiteColor];
       
        [self addTapGesture];
    }
    return self;
}

#pragma mark 添加手势识别器
-(void)addTapGesture
{
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapViewEvent)];
    tap.numberOfTapsRequired=1;
    [self addGestureRecognizer:tap];
}

- (void)tapViewEvent {
    if (_delegate && [_delegate respondsToSelector:@selector(tapCurrentView)]) {
        [_delegate tapCurrentView];
    }
}


- (void)bindData:(BTWeatherModel *)model {
    self.cityName.text = model.city;
    self.weatherInfo.text = [[NSString alloc] initWithFormat:@"%@℃ ~ %@℃", model.maxTemperature, model.minTemperature];
    
    if (!model.dayWeatherIcon) {
        [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
    }
    else {
        if ([model.dayWeatherIcon rangeOfString:@"雪"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_xue")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"晴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_qing")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"云"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_duoyun")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"雨"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yu")];
        }
        else if ([model.dayWeatherIcon rangeOfString:@"阴"].location != NSNotFound) {
            [self.weatherIcon setImage:BT_LOADIMAGE(@"weather_yin")];
        }
    }
}

- (UIView *)titleView {
    if (!_titleView) {
        _titleView = [[UIView alloc] init];
        _titleView.backgroundColor = [[BTThemeManager getInstance] BTThemeColor:@"cl_other_a_bg"];
    }
    return _titleView;
}

- (UILabel *)cityName {
    if (!_cityName) {
        _cityName = [[UILabel alloc] init];
    }
    return _cityName;
}

- (UILabel *)weatherInfo {
    if (!_weatherInfo) {
        _weatherInfo = [[UILabel alloc] init];
    }
    return _weatherInfo;
}

- (UIImageView *)weatherIcon {
    if (!_weatherIcon) {
        _weatherIcon = [[UIImageView alloc] init];
    }
    return _weatherIcon;
}

- (UILabel *)pm25Label {
    if (!_pm25Label) {
        _pm25Label = [[UILabel alloc] init];
    }
    return _pm25Label;
}

- (UIImageView *)pm25ImageView {
    if (!_pm25ImageView) {
        _pm25ImageView = [[UIImageView alloc] init];
    }
    return _pm25ImageView;
}

@end
