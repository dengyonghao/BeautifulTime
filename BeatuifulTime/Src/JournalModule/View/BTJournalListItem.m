//
//  BTJournalListItem.m
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/9.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import "BTJournalListItem.h"
#import "BTCalendarView.h"

@interface BTJournalListItem ()

@property (nonatomic, strong) BTCalendarView *calendarView;
@property (nonatomic, strong) UILabel *contentLaber;
@property (nonatomic, strong) UILabel *cityName;
@property (nonatomic, strong) UILabel *weatherInfo;
@property (nonatomic, strong) UIImageView *weatherIcon;
@property (nonatomic, strong) UILabel     *pm25Label;
@property (nonatomic, strong) UIImageView *pm25ImageView;
@property (nonatomic, strong) UIImageView *photoImageView;

@end

@implementation BTJournalListItem

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.calendarView];
        [self addSubview:self.cityName];
        [self addSubview:self.weatherIcon];
        [self addSubview:self.weatherInfo];
        [self addSubview:self.pm25Label];
        [self addSubview:self.pm25ImageView];
        [self addSubview:self.photoImageView];
        
        WS(weakSelf);
        [self.calendarView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(weakSelf).offset(5);
            make.top.equalTo(weakSelf).offset(5);
            make.width.equalTo(@(70));
            make.height.equalTo(@(70));
        }];
        [self.cityName mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.weatherIcon mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.weatherInfo mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.pm25Label mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.pm25ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
        }];
        [self.photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(weakSelf).offset(5);
            make.right.equalTo(weakSelf).offset(-5);
            make.width.equalTo(@(50));
            make.height.equalTo(@(70));
        }];
    }
    return self;
}

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (BTCalendarView *)calendarView {
    if (!_calendarView) {
        _calendarView = [[BTCalendarView alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        NSDate *date = [NSDate date];
        [_calendarView bindData:date];
    }
    return _calendarView;
}

- (UILabel *)contentLaber {
    if (!_contentLaber) {
        _contentLaber = [[UILabel alloc] init];
    }
    return _contentLaber;
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

- (UIImageView *)photoImageView {
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc] init];
    }
    return _photoImageView;
}

@end
