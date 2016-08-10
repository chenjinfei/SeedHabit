//
//  TabPageScrollView.h
//  mySeedHabit
//
//  Created by lanou on 16/8/5.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TabPageScrollViewPageItem : NSObject

@property (nonatomic,strong)NSString *tabName;

@property (nonatomic,strong)UIView *tabView;

- (instancetype)initWithTabName:(NSString *)tabName andTabView:(UIView *)tabView;

@end


@class TabPageScrollView;

@protocol TabPageScrollViewDelegate<NSObject>

@optional

- (void)TabPageScrollView:(TabPageScrollView *)tabPageScrollView decorateTabButton:(UIButton *)tabButton;

- (void)TabPageScrollView:(TabPageScrollView *)tabPageScrollView didPageItemSelected:(TabPageScrollViewPageItem *)pageItem withTabIndex:(NSInteger)tabIndex;

@end

@interface TabPageScrollViewParameter : NSObject

@property (nonatomic,assign)NSInteger tabHeight;
@property (nonatomic,strong)UIColor *indicatorColor;
@property (nonatomic,assign)NSInteger indicatorHeight;
@property (nonatomic,strong)UIColor *separatorColor;
@property (nonatomic,assign)NSInteger separatorHeight;
@property (nonatomic,assign)CGFloat indicatorWidthFactor;

@end


@interface TabPageScrollView : UIView

@property (nonatomic,weak)id<TabPageScrollViewDelegate>delegate;

- (instancetype)initWithPageItems:(NSArray *)pageItems;
- (instancetype)initWithPageItems:(NSArray *)pageItems withParameter:(TabPageScrollViewParameter *)parameter;

@end
