//
//  FSCalendarHeaderView.m
//  Test
//
//  Created by 樊盛 on 2019/5/8.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarHeaderView.h"
#import "CalendarMacroHeader.h"

@implementation FSCalendarHeaderView

- (instancetype)initWithFrame:(CGRect)frame withWeekNameArray:(NSArray *)weekNameArray {
    
    if (self = [super initWithFrame:frame]) {
        
        self.backgroundColor = Color_CalendarHeaderView_Bg;
        [self drawWeekHeaderViewWithFrame:frame withWeekNameArray:weekNameArray];
    }
    return self;
}

- (void)drawWeekHeaderViewWithFrame:(CGRect)frame withWeekNameArray:(NSArray *)weekNameArray {
    
    for (int i = 0; i < weekNameArray.count; i++) {
        
        CGFloat width = frame.size.width/weekNameArray.count;
        CGFloat height = frame.size.height;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i*width, 0, width, height)];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = Color_Text_CalendarHeaderView_Label;
        label.font = Font_CalendarHeaderLabel;
        label.text = weekNameArray[i];
        [self addSubview:label];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
