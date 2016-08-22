//
//  CalendarDateView.m
//  mySeedHabit
//
//  Created by lanou on 16/8/17.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "CalendarDateView.h"

#import "UIColor+CJFColor.h"

@implementation CalendarDateView
{
    UIButton  *_selectButton;
    NSMutableArray *_daysArray;
    
    UILabel *headlabel;
    
    UIButton *rightButton;
    UIButton *leftButton;
    
    NSDate *Date;
}

#pragma mark 初始化创建42个button
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _daysArray = [NSMutableArray arrayWithCapacity:42];
        for (int i = 0; i < 42; i++) {
            UIButton *button = [[UIButton alloc] init];
            [self addSubview:button];
            [_daysArray addObject:button];
        }
    }
    return self;
}

#pragma mark 给控件赋值
- (void)setDate:(NSDate *)date
{
    _date = date;
    [self createCalendarViewWith:date];
}

- (void)createCalendarViewWith:(NSData *)date
{
    Date = self.date;
    CGFloat itemW = self.frame.size.width / 7;
    CGFloat itemH = self.frame.size.height / 7;
    // 显示年月日
    headlabel = [[UILabel alloc]init];
    headlabel.text = [NSString stringWithFormat:@"%li-%li",[CalendarDate year:date],[CalendarDate month:date]];
    headlabel.font = [UIFont systemFontOfSize:14];
    headlabel.textAlignment = NSTextAlignmentCenter;
    headlabel.frame = CGRectMake(SCREEN_WIDTH/2-50, 0, 100, itemH);
    [self addSubview:headlabel];
    
    // 上个月按钮
    leftButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    leftButton.frame = CGRectMake(headlabel.frame.origin.x-50, 0, 40, itemH);
    [leftButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:leftButton];
    UIImageView *leftImg=[[UIImageView alloc] initWithFrame:CGRectMake(leftButton.frame.size.width-10, (leftButton.frame.size.height-15)/2, 10, 15)];
    leftImg.image=[UIImage imageNamed:@"add_32.png"];
    [leftButton addSubview:leftImg];
    
    // 下个月按钮
    rightButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    rightButton.frame=CGRectMake(CGRectGetMaxX(headlabel.frame)+50-itemH, leftButton.frame.origin.y, leftButton.frame.size.width, leftButton.frame.size.height);
    [rightButton addTarget:self action:@selector(clickMonth:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:rightButton];
    UIImageView *rightImg=[[UIImageView alloc] initWithFrame:CGRectMake(0, (rightButton.frame.size.height-15)/2, 10, 15)];
    rightImg.image=[UIImage imageNamed:@"add_32.png"];
    [rightButton addSubview:rightImg];
    
    // 星期
    NSArray *array = @[@"周日", @"周一", @"周二", @"周三", @"周四", @"周五", @"周六"];
    UIView *weekBg = [[UIView alloc] init];
    weekBg.frame = CGRectMake(0, CGRectGetMaxY(headlabel.frame), self.frame.size.width, itemH-10);
    [self addSubview:weekBg];
    
    for (int i = 0; i < 7; i++) {
        UILabel *week = [[UILabel alloc] init];
        week.text     = array[i];
        week.font     = [UIFont systemFontOfSize:14];
        week.frame    = CGRectMake(itemW * i, 0, itemW, 32);
        week.textAlignment   = NSTextAlignmentCenter;
        week.backgroundColor = [UIColor clearColor];
        week.textColor       = [UIColor darkGrayColor];
        [weekBg addSubview:week];
    }
    NSInteger daysInLastMonth = [CalendarDate totaldaysInMonth:[CalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [CalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [CalendarDate firstWeekdayInThisMonth:date];
    //  3.days (1-31)
    for (int i = 0; i < 42; i++) {
        
        int x = (i % 7) * itemW + 8 ;
        int y = (i / 7) * itemH + CGRectGetMaxY(weekBg.frame) + 8;
        
        UIButton *dayButton = _daysArray[i];
        
        dayButton.frame = CGRectMake(x, y, itemW*0.6, itemH*0.6);
        
        dayButton.titleLabel.font = [UIFont systemFontOfSize:14.0];
        dayButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        dayButton.layer.cornerRadius = 10;
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        // this month
        if ([CalendarDate month:date] == [CalendarDate month:[NSDate date]]) {
            
            NSInteger todayIndex = [CalendarDate day:date] + firstWeekday - 1;
            
            if (i <= todayIndex && i >= firstWeekday) {
                [self setStyle_BeforeToday:dayButton];
                [self setSign:i andBtn:dayButton];
            }
        }
    }
}

#pragma mark 设置已经签到
- (void)setSign:(int)i andBtn:(UIButton*)dayButton{
    [_signArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        int now = i;
        int now2 = [obj intValue];
        if (now2== now) {
            [self setStyle_SignEd:dayButton];
        }
    }];
}

//设置不是本月的日期字体颜色   ---白色  看不到
- (void)setStyle_BeyondThisMonth:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

// 这个月今天之后的日期的style
- (void)setStyle_AfterToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
}

//这个月 今日之前的日期style
- (void)setStyle_BeforeToday:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
}

//已经签过的日期style
- (void)setStyle_SignEd:(UIButton *)btn
{
    btn.enabled = NO;
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundColor:[UIColor colorWithHexString:UIMainColor alpha:1]];
}

// 获取头部显示的日期
-(BOOL) judgementMonth
{
    //获取当前月份
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM";
    NSInteger dateMon = [[formatter stringFromDate:[NSDate date]] integerValue];
    
    //获取选择的月份
    NSInteger mon = [[headlabel.text substringFromIndex:5] integerValue];
    
    if (mon == dateMon)
    {
        return YES;
    }else
        return NO;
}

// 月份的跳转
-(void) clickMonth:(UIButton *)btn
{
    if (btn == rightButton)
    {
        Date = [CalendarDate nextMonth:Date];
    }else
    {
        Date = [CalendarDate lastMonth:Date];
    }
    
    NSDate *date=Date;
    
    headlabel.text = [NSString stringWithFormat:@"%li-%li",[CalendarDate year:date],[CalendarDate month:date]];
    
    NSInteger daysInLastMonth = [CalendarDate totaldaysInMonth:[CalendarDate lastMonth:date]];
    NSInteger daysInThisMonth = [CalendarDate totaldaysInMonth:date];
    NSInteger firstWeekday    = [CalendarDate firstWeekdayInThisMonth:date];
    
    NSInteger todayIndex = [CalendarDate day:[NSDate date]] + firstWeekday - 1;
    
    for (int i = 0; i < 42; i++) {
        
        UIButton *dayButton = _daysArray[i];
        
        NSInteger day = 0;
        
        if (i < firstWeekday) {
            day = daysInLastMonth - firstWeekday + i + 1;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else if (i > firstWeekday + daysInThisMonth - 1){
            day = i + 1 - firstWeekday - daysInThisMonth;
            [self setStyle_BeyondThisMonth:dayButton];
            
        }else{
            day = i - firstWeekday + 1;
            [self setStyle_AfterToday:dayButton];
        }
        
        [dayButton setTitle:[NSString stringWithFormat:@"%li", day] forState:UIControlStateNormal];
        
        if([self judgementMonth] && i ==  todayIndex)
        {
            _dayButton = dayButton;
        }else
        {
            dayButton.backgroundColor=[UIColor whiteColor];
        }
    }
}

@end
