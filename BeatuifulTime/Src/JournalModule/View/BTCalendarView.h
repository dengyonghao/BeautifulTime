//
//  BTCalendarView.h
//  BeatuifulTime
//
//  Created by dengyonghao on 15/12/14.
//  Copyright © 2015年 dengyonghao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BTStatusViewDelegate;

@interface BTCalendarView : UIView

@property (nonatomic, weak) id <BTStatusViewDelegate> delegate;

- (void)bindData:(NSDate *)date;

@end

@protocol BTStatusViewDelegate <NSObject>

@optional

- (void)tapCurrentView;

@end
