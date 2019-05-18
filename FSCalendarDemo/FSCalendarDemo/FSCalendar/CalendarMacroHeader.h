//
//  GeneralMacroHeader.h
//  Test
//
//  Created by 樊盛 on 2019/5/7.
//  Copyright © 2019年 樊盛. All rights reserved.
//

#ifndef CalendarMacroHeader_h
#define CalendarMacroHeader_h

#define kScreenWidth   [[UIScreen mainScreen]bounds].size.width
#define kScreenHeight  [[UIScreen mainScreen]bounds].size.height

// 日历头的高度
#define kCalendarHeaderViewHeight 30

// 日历头 文字的颜色
#define Color_Text_CalendarHeaderView_Label [UIColor colorWithRed:(23)/255.0f green:(23)/255.0f blue:(23)/255.0f alpha:1]
// 上月||下月 文字的颜色
#define Color_Text_PreviousOrNextMonth [UIColor colorWithRed:(102)/255.0f green:(102)/255.0f blue:(102)/255.0f alpha:1]
// 当前月 选中的日期 文字的颜色
#define Color_Text_CurrentMonth_Selected [UIColor whiteColor]
// 当前月 未选中日期 文字的颜色
#define Color_Text_CurrentMonth_UnSelected [UIColor colorWithRed:(23)/255.0f green:(23)/255.0f blue:(23)/255.0f alpha:1]

// 日历头背景色
#define Color_CalendarHeaderView_Bg [UIColor colorWithRed:(235)/255.0f green:(236)/255.0f blue:(237)/255.0f alpha:1]
// collectionView 的背景色
#define Color_collectionView_Bg [UIColor colorWithRed:(235)/255.0f green:(236)/255.0f blue:(237)/255.0f alpha:1]
// currentSelectView 当前日期的边框颜色
#define Color_currentSelectView_Border_CurrentDay [UIColor orangeColor]
// currentSelectView 选中时的背景色
#define Color_currentSelectView_Bg_Selected [UIColor orangeColor]

// 日历头 label的字体大小
#define Font_CalendarHeaderLabel [UIFont systemFontOfSize:11]
// 阳历label的字体大小
#define Font_solarDateLabel [UIFont systemFontOfSize:16]
// 农历label的字体大小
#define Font_lunarDateLabel [UIFont systemFontOfSize:10]



#endif /* CalendarMacroHeader_h */
