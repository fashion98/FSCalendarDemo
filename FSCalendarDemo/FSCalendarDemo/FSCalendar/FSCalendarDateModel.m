//
//  FSCalendarDateModel.m
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarDateModel.h"
#import "NSDate+FSCalendar.h"
#import "FSCalendarDayModel.h"

@implementation FSCalendarDateModel

- (instancetype)initWithDate:(NSDate *)date {
    
    if (self = [super init]) {
        
        self.date = date;
        self.totalDays = [self.date totalDaysInMonth];
        self.firstWeekday = [self.date firstWeekDayInMonth];
        self.year = [self.date dateYear];
        self.month = [self.date dateMonth];
        
        [self dealData];
    }
    
    return self;
}

- (void)dealData {
    
    self.monthModelList = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    
    // 当前月上月末尾的几天
    NSInteger previousMonthTotalDays = [self.date previousMonthDate].totalDaysInMonth;
    NSInteger year = self.month==1 ? self.year-1 : self.year;
    NSInteger month = self.month==1 ? 12 : self.month-1;
    
    for (NSInteger i = previousMonthTotalDays-self.firstWeekday+1; i < previousMonthTotalDays+1; i++) {
        NSDate *currentDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld", year, month, i]];
        FSCalendarDayModel *dayModel = [FSCalendarDayModel new];
        dayModel.solarDateString = [NSString stringWithFormat:@"%02ld", i];
        dayModel.lunarDateString = currentDate.lunarText;
        [self.monthModelList addObject:dayModel];
    }
    
    // 当前月所有
    for (NSInteger i = 1; i < self.date.totalDaysInMonth+1; i++) {
        NSDate *currentDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld", self.year, self.month, i]];
        FSCalendarDayModel *dayModel = [FSCalendarDayModel new];
        dayModel.solarDateString = [NSString stringWithFormat:@"%02ld", i];
        dayModel.lunarDateString = currentDate.lunarText;
        [self.monthModelList addObject:dayModel];
    }
    
    // 下月开始的几天
    NSInteger number = self.firstWeekday+self.totalDays;
    number = 42-number;//number > 35 ? 42-number : 35-number;
    NSInteger year1 = self.month==12 ? self.year+1 : self.year;
    NSInteger month1 = self.month==12 ? 1 : self.month+1;
    for (NSInteger i = 1; i < number+1; i++) {
        NSDate *currentDate = [dateFormatter dateFromString:[NSString stringWithFormat:@"%ld-%ld-%ld", year1, month1, i]];
        FSCalendarDayModel *dayModel = [FSCalendarDayModel new];
        dayModel.solarDateString = [NSString stringWithFormat:@"%02ld", i];
        dayModel.lunarDateString = currentDate.lunarText;
        [self.monthModelList addObject:dayModel];
    }

}


@end
