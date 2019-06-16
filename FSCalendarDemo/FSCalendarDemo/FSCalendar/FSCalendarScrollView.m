//
//  FSCalendarScrollView.m
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarScrollView.h"
#import "FSCalendarCell.h"
#import "FSCalendarDateModel.h"
#import "FSCalendarDayModel.h"
#import "NSDate+FSCalendar.h"
#import "CalendarMacroHeader.h"

@interface FSCalendarScrollView() <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionViewL;// 左侧collectionView
@property (nonatomic, strong) UICollectionView *collectionViewM;// 中间collectionView
@property (nonatomic, strong) UICollectionView *collectionViewR;// 右侧collectionView

@property (nonatomic, strong) NSMutableArray<FSCalendarDateModel *> *monthArray;// 数据源array

@end

static NSString *const cellIdOfFSCalendarCell = @"FSCalendarCell";
@implementation FSCalendarScrollView

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray arrayWithCapacity:3];
        
        NSDate *previousMonthDate = [self.currentMonthDate previousMonthDate];// 上个月的今天
        NSDate *nextMonthDate = [self.currentMonthDate nextMonthDate];// 下个月的今天
        
        // 添加上月、当前月、下月 数据
        [_monthArray addObject:[[FSCalendarDateModel alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[FSCalendarDateModel alloc] initWithDate:self.currentMonthDate]];
        [_monthArray addObject:[[FSCalendarDateModel alloc] initWithDate:nextMonthDate]];
    }
    
    return _monthArray;
}

// pointsArray set方法
- (void)setPointsArray:(NSMutableArray<NSString *> *)pointsArray {
    
    FSCalendarDateModel *dateModel = self.monthArray[1];
    dateModel.pointsArray = [NSMutableArray arrayWithArray:pointsArray];
}

// pointsArray get方法
- (NSMutableArray<NSString *> *)pointsArray {
    
    FSCalendarDateModel *dateModel = self.monthArray[1];
    return dateModel.pointsArray;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = Color_collectionView_Bg;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        self.scrollsToTop = NO;
        
        self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO];
        
        self.currentMonthDate = [NSDate date];
        self.currentDateNumber = [self.currentMonthDate dateDay];
        
        // 初始化三个collectionView
        [self setupCollectionViews];
        
        // 默认选中当前日期，回传当前日期
        [self passDate];
    }
    
    return self;
}

- (void)setupCollectionViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake(self.bounds.size.width / 7.0, self.bounds.size.height / 6.0);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    // 遍历创建3个collectionView
    for (int i = 0; i < self.monthArray.count; i++) {
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(i*selfWidth, 0.0, selfWidth, selfHeight) collectionViewLayout:flowLayout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        collectionView.bounces = NO;
        collectionView.backgroundColor = Color_collectionView_Bg;
        [collectionView registerClass:[FSCalendarCell class] forCellWithReuseIdentifier:cellIdOfFSCalendarCell];
        [self addSubview:collectionView];
        if (i == 0) {
            self.collectionViewL = collectionView;
        }else if (i == 1) {
            self.collectionViewM = collectionView;
        }else if (i == 2) {
            self.collectionViewR = collectionView;
        }
    }
}

#pragma mark ---- collectionView delegate ----
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return 42; // 7 * 6
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdOfFSCalendarCell forIndexPath:indexPath];
    
    if (collectionView == self.collectionViewL) {
        
        [self layoutCollectionViewsDataWithCell:cell IndexPath:indexPath withDataIndex:0];
    }else if (collectionView == self.collectionViewM) {
        
        [self layoutCollectionViewsDataWithCell:cell IndexPath:indexPath withDataIndex:1];
    }else if (collectionView == self.collectionViewR) {
        
        [self layoutCollectionViewsDataWithCell:cell IndexPath:indexPath withDataIndex:2];
    }
    
    return cell;
}

// 布局各collectionView的数据及控件属性等
- (void)layoutCollectionViewsDataWithCell:(FSCalendarCell *)cell IndexPath:(NSIndexPath *)indexPath withDataIndex:(NSInteger)index {
    
    FSCalendarDateModel *monthInfo = self.monthArray[index];
    FSCalendarDayModel *dayModel = monthInfo.monthModelList[indexPath.row];
    NSInteger firstWeekday = monthInfo.firstWeekday;// 一个月的第一天是星期几
    NSInteger totalDays = monthInfo.totalDays;// 一个月的总天数
    
    // model赋值
    cell.dayModel = dayModel;
    
    if (indexPath.row < firstWeekday) {// 上月末尾的几天
        
        cell.solarDateLabel.textColor = Color_Text_PreviousOrNextMonth;
        cell.lunarDateLabel.textColor = Color_Text_PreviousOrNextMonth;
        cell.pointView.hidden = YES;
        
    }else if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {// 当前月所有日期
        
        if (index == 1) {
            
            // 假如当前选中了31日，左滑或右滑 那个月没有31日，则需要选中那个月的最后一天
            self.currentDateNumber = self.currentDateNumber > totalDays ? totalDays : self.currentDateNumber;

            if (self.currentDateNumber+firstWeekday-1 == indexPath.row) { //当前选中日期
                
                cell.solarDateLabel.textColor = Color_Text_CurrentMonth_Selected;
                cell.lunarDateLabel.textColor = Color_Text_CurrentMonth_Selected;
                cell.currentSelectView.backgroundColor = Color_currentSelectView_Bg_Selected;
            }else if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear]) && (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1)) { //当前日期

                cell.currentSelectView.layer.borderColor = Color_currentSelectView_Border_CurrentDay.CGColor;
                cell.currentSelectView.layer.borderWidth = 1;
            }
            
            BOOL isHaving = NO;// pointsArray 中是否包含当前日期
            for (NSString *pointString in self.pointsArray) {
                
                NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
                dateF.dateFormat = @"yyyy-MM-dd";
                NSDate *date = [dateF dateFromString:pointString];
                
                if (date.dateYear == monthInfo.year && date.dateMonth == monthInfo.month && date.dateDay == indexPath.row-firstWeekday+1) {
                    isHaving = YES;
                }
            }
            
            cell.pointView.hidden = !isHaving;
        }
    }else if (indexPath.row >= firstWeekday + totalDays) {// 下月开始的几天
        
        cell.solarDateLabel.textColor = Color_Text_PreviousOrNextMonth;
        cell.lunarDateLabel.textColor = Color_Text_PreviousOrNextMonth;
        cell.pointView.hidden = YES;
    }
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FSCalendarDateModel *monthInfo = self.monthArray[1];
    NSInteger firstWeekday = monthInfo.firstWeekday;
    
    // 记录当前选中的日期number
    self.currentDateNumber = [monthInfo.monthModelList[indexPath.row].solarDateString integerValue];
    
    if (indexPath.row < firstWeekday) {// 点击当前collectionView上月日期，需要移动到上月所在月
        
        [self pushToPreviousMonthOrNextMonthWithPageIndex:0];
    }else if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + monthInfo.totalDays) {
        
        // 回传日期并刷新界面
        [self passDate];
        [self.collectionViewM reloadData];
    }else if (indexPath.row >= firstWeekday + monthInfo.totalDays) {// 点击当前collectionView下月日期，需要移动到下月所在月
        
        [self pushToPreviousMonthOrNextMonthWithPageIndex:2];
    }
    
}

// 移动到上月或下月
- (void)pushToPreviousMonthOrNextMonthWithPageIndex:(NSInteger)pageIndex {
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.contentOffset = CGPointMake(self.bounds.size.width*pageIndex, 0.0);
    } completion:^(BOOL finished) {
        
        if (finished) {
            
            // 移动完成后，重新设置数据源
            [self scrollViewDidEndDecelerating:self];
        }
    }];
}

// 回到今天
- (void)refreshToCurrentDate {
    
    // 只需要置为nil，用到的时候就会自动重新初始化
    self.monthArray = nil;
    
    // 设置currentMonthDate 及 currentDateNumber
    self.currentMonthDate = [NSDate date];
    self.currentDateNumber = [self.currentMonthDate dateDay];
    
    // 刷新collectionViews
    [self reloadCollectionViews];
    
    // 回到今天，需要重新设置scrollView的偏移量
    [self setScrollViewContentOffset];
    
    // 回传日期
    [self passDate];
}

#pragma mark ---- scrollView delegate ----
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x < self.bounds.size.width) { // 向右滑动
        
        self.currentMonthDate = [self.currentMonthDate previousMonthDate];
        
        // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
        FSCalendarDateModel *previousMonthInfo = [[FSCalendarDateModel alloc] initWithDate:[self.currentMonthDate previousMonthDate]];
        FSCalendarDateModel *currentMothInfo = self.monthArray[0];
        FSCalendarDateModel *nextMonthInfo = self.monthArray[1];

        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        
        [self setScrollViewContentOffset];
        [self reloadCollectionViews];
        [self passDate];
        
    }else if (scrollView.contentOffset.x > self.bounds.size.width) { // 向左滑动
        
        self.currentMonthDate = [self.currentMonthDate nextMonthDate];
        
        // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
        FSCalendarDateModel *previousMonthInfo = self.monthArray[1];
        FSCalendarDateModel *currentMothInfo = self.monthArray[2];
        FSCalendarDateModel *nextMonthInfo = [[FSCalendarDateModel alloc] initWithDate:[self.currentMonthDate nextMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        
        [self setScrollViewContentOffset];
        [self reloadCollectionViews];
        [self passDate];
    }
    else {

        [self setScrollViewContentOffset];
        return;
    }

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView.contentOffset.x == kScreenWidth && scrollView.contentOffset.y == 0.00f && self.isShowSingle) {
        
        [self setScrollViewContentOffset];
    }
}

#pragma mark ---- 设置scrollView的偏移量 ----
- (void)setScrollViewContentOffset {
    
    CGFloat offsetY = 0;
    if (self.isShowSingle) {
        
        // 假如当前选中了31日，左滑或右滑 那个月没有31日，则需要选中那个月的最后一天
        self.currentDateNumber = self.currentDateNumber > self.currentMonthDate.totalDaysInMonth ? self.currentMonthDate.totalDaysInMonth : self.currentDateNumber;
        
        NSInteger index = [self.currentMonthDate firstWeekDayInMonth]+self.currentDateNumber;
        NSInteger rows = index%7 == 0 ? index/7-1 : index/7;
        offsetY = rows*(self.frame.size.height/6);
    }
    self.contentOffset = CGPointMake(self.bounds.size.width, offsetY);
}

#pragma mark ---- 回传所选日期 ----
- (void)passDate {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.passDateBlock) {
            self.passDateBlock([self.currentMonthDate otherDayInMonth:self.currentDateNumber]);
        }
    });
}

#pragma mark ---- 刷新collectionViews ----
- (void)reloadCollectionViews {
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end
