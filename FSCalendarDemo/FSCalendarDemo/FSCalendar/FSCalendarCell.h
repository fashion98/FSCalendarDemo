//
//  FSCalendarCell.h
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//  日历collectionViewCell

#import <UIKit/UIKit.h>
@class FSCalendarDayModel;

@interface FSCalendarCell : UICollectionViewCell

/** 阳历日期label（eg：1、2、3日） */
@property (nonatomic, strong) UILabel *solarDateLabel;

/** 农历日期label（eg：初一、初二、初三） */
@property (nonatomic, strong) UILabel *lunarDateLabel;

/** 当前选中日期的蒙版view（标记选中） */
@property (nonatomic, strong) UILabel *currentSelectView;

/** 小圆点 */
@property (nonatomic, strong) UIView *pointView;

/** FSCalendarDayModel（获取阳历、农历string） */
@property (nonatomic, strong) FSCalendarDayModel *dayModel;


@end
