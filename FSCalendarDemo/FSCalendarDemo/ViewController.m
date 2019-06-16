//
//  ViewController.m
//  FSCalendarDemo
//
//  Created by 樊盛 on 2019/5/17.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "ViewController.h"
#import "FSCalendarView.h"
#import "NSDate+FSCalendar.h"

@interface ViewController ()<FSCalendarDelegate>

@property (nonatomic, strong) FSCalendarView *calendarView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 回今天
    [self initRightBarbutton];
    
    // 初始化日历
    [self initCalendarView];
}

- (void)initRightBarbutton {
    
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"今天" style:(UIBarButtonItemStylePlain) target:self action:@selector(refreshToCurrentDate)];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)initCalendarView {
    
    // demo 的 frame 我就简单随便一写，项目中根据实际给值即可
    self.calendarView = [[FSCalendarView alloc] initWithFrame:CGRectMake(0, 88, kScreenWidth, kScreenHeight-88) withCalendarHeight:kScreenWidth*6/7+kCalendarHeaderViewHeight withShowSingle:YES];
    self.calendarView.fsDelegate = self;
    [self.view addSubview:self.calendarView];
    
}

// 回今天
- (void)refreshToCurrentDate {
    
    [self.calendarView refreshToCurrentDate];
}

- (void)calendarDidSelectedWithDate:(NSDate *)date {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd";
    self.title = [dateFormatter stringFromDate:date];
    
    // 模拟数据
    NSMutableArray *arr = [NSMutableArray array];
    for (int i = 0; i < 5; i++) {
        NSInteger random = arc4random()%31+1;
        [arr addObject:[NSString stringWithFormat:@"%zd-%02zd-%02zd", [NSDate date].dateYear, [NSDate date].dateMonth, random]];
    }
    
    // 赋值pointsArray
    self.calendarView.calendarScrollView.pointsArray = arr;
    // 刷新collectionViews
    [self.calendarView.calendarScrollView reloadCollectionViews];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

