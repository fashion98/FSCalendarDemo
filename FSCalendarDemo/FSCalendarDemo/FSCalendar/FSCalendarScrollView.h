//
//  FSCalendarScrollView.h
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//  单纯的日历scrollView

#import <UIKit/UIKit.h>

typedef void(^PassDateBlock)(NSDate *date);// 点击日期block
@interface FSCalendarScrollView : UIScrollView

/** 日期传递block */
@property (nonatomic, copy) PassDateBlock passDateBlock;

/** 当前月的日期 */
@property (nonatomic, strong) NSDate *currentMonthDate;

/** 当前选中的cell的日期（eg：7、19、31） */
@property (nonatomic, assign) NSInteger currentDateNumber;

/** 是否单行显示 */
@property (nonatomic, assign) BOOL isShowSingle;

/** 当前月有小圆点标记的dateString数组 */
@property (nonatomic, strong) NSMutableArray<NSString *> *pointsArray;

/** 刷新collectionView */
- (void)reloadCollectionViews;

/** 回到今天 */
- (void)refreshToCurrentDate;

@end
