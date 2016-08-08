//
//  HeaderView.m
//  mySeedHabit
//
//  Created by lanou on 16/8/4.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "HeaderView.h"

@implementation HeaderView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (void)baseInit
{
    CGRect frame = self.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 180;
    [self setFrame:frame];
    UIView *view = nil;
    NSArray *objects = [[NSBundle mainBundle]loadNibNamed:@"HeaderView" owner:self options:nil];
    for (id object in objects) {
        if ([object isKindOfClass:[UIView class]]) {
            view = object;
            break;
        }
    }
    if (view != nil) {
        [self addSubview:view];
    }
}

- (void)layoutSubviews
{
    CGRect frame = self.frame;
    frame.size.width = SCREEN_WIDTH;
    frame.size.height = 180;
    [self setFrame:frame];
}

@end
