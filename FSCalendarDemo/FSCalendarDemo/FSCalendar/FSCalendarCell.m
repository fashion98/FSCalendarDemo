//
//  FSCalendarCell.m
//  Test
//
//  Created by 樊盛 on 2019/4/29.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#import "FSCalendarCell.h"
#import "FSCalendarDayModel.h"
#import "CalendarMacroHeader.h"

@implementation FSCalendarCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = Color_collectionView_Bg;
        [self drawView];
    }
    return self;
}

- (void)drawView {
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat rate = 0.13;
    CGFloat gap = selfWidth*rate;
    CGFloat width = selfWidth*(1-2*rate);
    self.currentSelectView = [[UILabel alloc] initWithFrame:CGRectMake(gap, gap/5, width, width)];
    self.currentSelectView.layer.cornerRadius = width/2;
    self.currentSelectView.layer.masksToBounds = YES;
    [self addSubview:self.currentSelectView];
    
    self.solarDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width/2*0.2, width, width/2*0.8)];
    self.solarDateLabel.textAlignment = NSTextAlignmentCenter;
    self.solarDateLabel.font = Font_solarDateLabel;
    [self.currentSelectView addSubview:self.solarDateLabel];
    
    self.lunarDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, width/2, width, width/2*0.8)];
    self.lunarDateLabel.textAlignment = NSTextAlignmentCenter;
    self.lunarDateLabel.font = Font_lunarDateLabel;
    [self.currentSelectView addSubview:self.lunarDateLabel];
    
    self.pointView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 5)];
    self.pointView.center = CGPointMake(self.bounds.size.width/2, (self.bounds.size.height-CGRectGetMaxY(self.currentSelectView.frame))/2+CGRectGetMaxY(self.currentSelectView.frame));
    self.pointView.layer.cornerRadius = self.pointView.bounds.size.width/2;
    self.pointView.backgroundColor = [UIColor orangeColor];
    self.pointView.hidden = YES;
    [self addSubview:self.pointView];
    
}

- (void)setDayModel:(FSCalendarDayModel *)dayModel {
    
    self.solarDateLabel.text = dayModel.solarDateString;
    self.solarDateLabel.textColor = Color_Text_CurrentMonth_UnSelected;
    self.lunarDateLabel.text = dayModel.lunarDateString;
    self.lunarDateLabel.textColor = Color_Text_CurrentMonth_UnSelected;
    self.currentSelectView.backgroundColor = [UIColor clearColor];
    self.currentSelectView.layer.borderWidth = 0;
}




@end
