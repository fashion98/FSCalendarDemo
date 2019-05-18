//
//  FSCalendarView.h
//  Test
//
//  Created by 樊盛 on 2019/5/6.
//  Copyright © 2019年 樊盛. All rights reserved.
//  日历封装view（只有日历 或者 下方带自定义view的日历）

#import <UIKit/UIKit.h>
#import "FSCalendarScrollView.h"
#import "CalendarMacroHeader.h"

@protocol FSCalendarDelegate <NSObject>

/** 获得点击的日期 */
- (void)calendarDidSelectedWithDate:(NSDate *)date;

@end
@interface FSCalendarView : UIView

/** 代理属性 */
@property (nonatomic, weak) id<FSCalendarDelegate> fsDelegate;

/** 日历view */
@property (nonatomic, strong) FSCalendarScrollView *calendarScrollView;

/** 日历下方自定义view */
@property (nonatomic, strong) UIView *customView;

/**
 *  单纯的日历（日历头+日历）
 *  frame的height一般传 kScreenWidth*6/7+kCalendarHeaderViewHeight
 */
- (instancetype)initWithFrame:(CGRect)frame;

/**
 *  日历下方带自定义view
 *  参数一：日历头+日历+自定义view的frame
 *  参数二：日历头+日历的高度（一般传 kScreenWidth*6/7+kCalendarHeaderViewHeight）
 *  参数三：初始化后是否单行显示
 */
- (instancetype)initWithFrame:(CGRect)frame withCalendarHeight:(CGFloat)calendarHeight withShowSingle:(BOOL)isShowSingle;

/**
 *  回到今天点击方法
 */
- (void)refreshToCurrentDate;

@end
