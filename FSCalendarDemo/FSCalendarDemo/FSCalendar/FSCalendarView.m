//
//  FSCalendarView.m
//  Test
//
//  Created by 樊盛 on 2019/5/6.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarView.h"
#import "FSCalendarHeaderView.h"
#import "NSDate+FSCalendar.h"

@interface FSCalendarView ()

/** 日历头view（日、一、二、三...） */
@property (nonatomic, strong) FSCalendarHeaderView *calendarHeaderView;

@end

@implementation FSCalendarView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initCalendarHeaderViewWithFrame:frame withCalendarHeaderViewHeight:kCalendarHeaderViewHeight];
        [self initFSCalendarScrollViewWithFrame:frame withCalendarScrollViewHeight:frame.size.height-kCalendarHeaderViewHeight withShowSingle:NO];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withCalendarHeight:(CGFloat)calendarHeight withShowSingle:(BOOL)isShowSingle {
    
    if (self = [super initWithFrame:frame]) {
        
        [self initCalendarHeaderViewWithFrame:frame withCalendarHeaderViewHeight:kCalendarHeaderViewHeight];
        [self initFSCalendarScrollViewWithFrame:frame withCalendarScrollViewHeight:calendarHeight-kCalendarHeaderViewHeight withShowSingle:isShowSingle];

        CGFloat originY = isShowSingle ? self.calendarScrollView.frame.size.height/6+kCalendarHeaderViewHeight : CGRectGetMaxY(self.calendarScrollView.frame);
        [self initCustomViewWithFrame:frame withCustomViewOriginY:originY];
        
        //上滑下滑手势
        UISwipeGestureRecognizer *recognizer;
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionUp)];
        [self addGestureRecognizer:recognizer];
        
        recognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeFrom:)];
        [recognizer setDirection:(UISwipeGestureRecognizerDirectionDown)];
        [self addGestureRecognizer:recognizer];
    }
    return self;
}

#pragma mark ---- 创建日历头view ----
- (void)initCalendarHeaderViewWithFrame:(CGRect)frame withCalendarHeaderViewHeight:(CGFloat)calendarHeaderViewHeight {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSMutableArray *days = [[dateFormatter veryShortStandaloneWeekdaySymbols] mutableCopy];// 非常短，可以改其它枚举值
    self.calendarHeaderView = [[FSCalendarHeaderView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, calendarHeaderViewHeight) withWeekNameArray:days];
    [self addSubview:self.calendarHeaderView];
}

#pragma mark ---- 创建日历view ----
- (void)initFSCalendarScrollViewWithFrame:(CGRect)frame withCalendarScrollViewHeight:(CGFloat)calendarScrollViewHeight withShowSingle:(BOOL)isShowSingle {
    
    self.calendarScrollView = [[FSCalendarScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.calendarHeaderView.frame), frame.size.width, calendarScrollViewHeight)];
    
    self.calendarScrollView.isShowSingle = isShowSingle;
    if (isShowSingle) {// 创建的时候，如果单行显示，改变偏移量
        NSInteger index = [self.calendarScrollView.currentMonthDate firstWeekDayInMonth]+self.calendarScrollView.currentDateNumber;
        NSInteger rows = index%7 == 0 ? index/7-1 : index/7;
        CGFloat offset = rows*(self.calendarScrollView.frame.size.height/6);
        self.calendarScrollView.contentOffset = CGPointMake(self.bounds.size.width, offset);
    }
    __weak typeof(self)weakSelf = self;
    self.calendarScrollView.passDateBlock = ^(NSDate *date) {// 点击某一天的block回调
        if ([weakSelf.fsDelegate respondsToSelector:@selector(calendarDidSelectedWithDate:)]) {
            [weakSelf.fsDelegate calendarDidSelectedWithDate:date];
        }
    };
    [self addSubview:self.calendarScrollView];
}

#pragma mark ---- 创建日历下方自定义view ----
- (void)initCustomViewWithFrame:(CGRect)frame withCustomViewOriginY:(CGFloat)customViewOriginY {
    
    self.customView = [[UIView alloc] initWithFrame:CGRectMake(0, customViewOriginY, frame.size.width, frame.size.height-customViewOriginY)];
    self.customView.backgroundColor = [UIColor cyanColor];
    [self addSubview:self.customView];
}

#pragma mark ---- 上滑下滑手势响应事件 ----
- (void)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    
    //上滑--展示一行
    if (recognizer.direction==UISwipeGestureRecognizerDirectionUp) {
        
        if (self.calendarScrollView.isShowSingle) {
            return;
        }
        NSLog(@"swipe up");
        [self showSingleWeekView:YES];
    }
    
    //下滑--展示全部
    if (recognizer.direction==UISwipeGestureRecognizerDirectionDown) {
        if (!self.calendarScrollView.isShowSingle) {
            return;
        }
        NSLog(@"swipe down");
        [self showAllView:YES];
    }
}

#pragma mark ---- 只显示一周 ----
- (void)showSingleWeekView:(BOOL)animate {
    
    NSInteger index = [self.calendarScrollView.currentMonthDate firstWeekDayInMonth]+self.calendarScrollView.currentDateNumber;
    NSInteger rows = index%7 == 0 ? index/7-1 : index/7;
    CGFloat offset = rows*(self.calendarScrollView.frame.size.height/6);
    
    self.calendarScrollView.isShowSingle = YES;
    [self.calendarScrollView setContentOffset:CGPointMake(self.calendarScrollView.bounds.size.width, offset) animated:animate];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.customView.frame;
        rect.origin.y = self.calendarScrollView.frame.size.height/6+kCalendarHeaderViewHeight;
        rect.size.height = self.frame.size.height-rect.origin.y;
        self.customView.frame = rect;
    }];
}

#pragma mark ---- 显示全部 ----
- (void)showAllView:(BOOL)animate {
    
    self.calendarScrollView.isShowSingle = NO;
    [self.calendarScrollView setContentOffset:CGPointMake(self.calendarScrollView.bounds.size.width, 0) animated:animate];
    [UIView animateWithDuration:0.3 animations:^{
        
        CGRect rect = self.customView.frame;
        rect.origin.y = CGRectGetMaxY(self.calendarScrollView.frame);
        rect.size.height = self.frame.size.height-rect.origin.y;
        self.customView.frame = rect;
    }];
    
}

#pragma mark ---- 回到今天点击方法 ----
- (void)refreshToCurrentDate {
    
    [self.calendarScrollView refreshToCurrentDate];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
