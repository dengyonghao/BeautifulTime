//
//  BTCalendarView.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BTCalendarView : UIView

- (void)bindData:(NSDate *)date;

@end

@protocol BTCalendarViewViewDelegate <NSObject>

@optional

- (void)tapCurrentView;

@end
