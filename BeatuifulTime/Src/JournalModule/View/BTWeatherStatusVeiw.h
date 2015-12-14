//
//  BTWeatherStatusVeiw.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BTWeatherModel.h"
#import "BTCalendarView.h"

@interface BTWeatherStatusVeiw : UIView

@property (nonatomic, weak) id <BTStatusViewDelegate> delegate;

- (void)bindData:(BTWeatherModel *)model;

@end
