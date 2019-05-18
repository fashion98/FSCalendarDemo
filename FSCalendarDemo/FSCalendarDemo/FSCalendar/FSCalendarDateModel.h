//
//  FSCalendarDateModel.h
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//  每个月的model

#import <Foundation/Foundation.h>
@class FSCalendarDayModel;

@interface FSCalendarDateModel : NSObject

/** monthModelList（上个月末尾的几天+当月所有日期+下个月开始的几天） */
@property (nonatomic, strong) NSMutableArray<FSCalendarDayModel *> *monthModelList;

/** 某月的当前日（eg：今天18号，每个collectionView对应的date值为当月的18号） */
@property (nonatomic, strong) NSDate *date;

/** 当前日期所在月的总天数 */
@property (nonatomic, assign) NSInteger totalDays;

/** 当前日期所属月第一天是星期几（0代表周日，1代表周一，以此类推） */
@property (nonatomic, assign) NSInteger firstWeekday;

/** 当前月有小圆点标记的dateString数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *pointsArray;

/** 当前日期所属年份 */
@property (nonatomic, assign) NSInteger year;

/** 当前月份所属月份 */
@property (nonatomic, assign) NSInteger month;

/** 传入date初始化model */
- (instancetype)initWithDate:(NSDate *)date;

@end
