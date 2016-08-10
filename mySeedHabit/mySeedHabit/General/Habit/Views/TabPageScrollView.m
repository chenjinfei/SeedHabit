//
//  TabPageScrollView.m
//  mySeedHabit
//
//  Created by lanou on 16/8/8.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "TabPageScrollView.h"
#import "Masonry.h"

@implementation TabPageScrollViewPageItem

-(instancetype)initWithTabName:(NSString *)tabName andTabView:(UIView *)tabView
{
    self = [super init];
    if (self) {
        _tabName = tabName;
        _tabView = tabView;
    }
    return self;
}

@end

@implementation TabPageScrollViewParameter

- (instancetype)init
{
    self = [super init];
    if (self) {
        _tabHeight = 50;
        _indicatorColor = nil;
        _indicatorHeight = 2;
        _separatorColor = nil;
        _separatorHeight = 1;
        _indicatorWidthFactor = 2.0/3.0;
    }
    return self;
}

@end

@interface TabPageScrollView()<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *contentView;

@property (nonatomic,strong)NSArray *pageItems;

@property (nonatomic,strong)NSMutableArray *tabButtons;

@property (nonatomic,strong)UIView *indicatorView;

@property (nonatomic,strong)UIView *separatorView;

@property (nonatomic,strong)TabPageScrollViewParameter *parameter;

@end

@implementation TabPageScrollView

- (instancetype)initWithPageItems:(NSArray *)pageItems withParameter:(TabPageScrollViewParameter *)parameter
{
    self = [super init];
    if (self) {
        if (parameter == nil) {
            _parameter = [TabPageScrollViewParameter new];
        }else{
            self.parameter = parameter;
        }
        _tabButtons = [NSMutableArray new];
        _pageItems = pageItems;
        [self loadUI];
    }
    return self;
}

- (instancetype)initWithPageItems:(NSArray *)pageItems
{
    return [self initWithPageItems:pageItems withParameter:nil];
}

#pragma mark 设计UI界面
- (void)loadUI
{
    UIView *rootView = self;
    UIView *tabView = [UIView new];
    [rootView addSubview:tabView];
    [tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootView.mas_left);
        make.top.equalTo(rootView.mas_top);
        make.right.equalTo(rootView.mas_right);
        make.height.equalTo(@40);
    }];
    [self subLoadTabView:tabView];
    
    _contentView = [UIScrollView new];
    [rootView addSubview:_contentView];
    _contentView.pagingEnabled = YES;
    _contentView.showsVerticalScrollIndicator = NO;
    _contentView.showsHorizontalScrollIndicator = NO;
    _contentView.delegate = self;
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(rootView.mas_left);
        make.right.equalTo(rootView.mas_right);
        make.bottom.equalTo(rootView.mas_bottom);
        make.top.equalTo(tabView.mas_bottom);
    }];
    [self subLoadContentView];
}

- (void)subLoadTabView:(UIView *)tabView
{
    [_pageItems enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        TabPageScrollViewPageItem *item = obj;
        
        UIButton *button = [UIButton new];
        [tabView addSubview:button];
        [_tabButtons addObject:button];
        
        [button setTitle:item.tabName forState:UIControlStateNormal];
        [button setTitleColor:RGB(120, 120, 120) forState:UIControlStateNormal];
        [button setTitleColor:RGB(30, 196, 97) forState:UIControlStateSelected];
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        
        if(_delegate && [_delegate respondsToSelector:@selector(TabPageScrollView:decorateTabButton:)]){
            [_delegate TabPageScrollView:self decorateTabButton:button];
        }
        
        [button addTarget:self action:@selector(tabButtonTouchUp:) forControlEvents:UIControlEventTouchUpInside];
        button.tag = idx;
        
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(tabView.mas_top);
            make.height.equalTo(@(_parameter.tabHeight - _parameter.indicatorHeight - _parameter.separatorHeight));
            if (idx == 0) {
                make.left.equalTo(tabView.mas_left);
            }else if (idx == _pageItems.count - 1){
                make.right.equalTo(tabView.mas_right);
            }
            
            if (idx > 0) {
                UIButton *leftButton = (UIButton *)_tabButtons[idx - 1];
                make.left.equalTo(leftButton.mas_right);
                
                make.width.equalTo(leftButton.mas_width);
            }
        }];
    }];
    
    _separatorView = [UIView new];
    [tabView addSubview:_separatorView];
    _separatorView.backgroundColor = RGB(146, 146, 146);
    [_separatorView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tabView.mas_left);
        make.right.equalTo(tabView.mas_right);
        make.height.equalTo(@(_parameter.separatorHeight));
        make.bottom.equalTo(tabView.mas_bottom);
    }];
    
    UIButton *firstButton = (UIButton *)_tabButtons[0];
    firstButton.selected = YES;
    
    _indicatorView = [UIView new];
    [tabView addSubview:_indicatorView];
    _indicatorView.backgroundColor = RGB(30, 196, 97);
    [_indicatorView mas_makeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@(SCREEN_WIDTH / _pageItems.count * _parameter.indicatorWidthFactor));
        make.bottom.equalTo(_separatorView.mas_top);
        make.height.equalTo(@(_parameter.indicatorHeight));
        make.centerX.equalTo(firstButton.mas_centerX);
    }];
}

- (void)tabButtonTouchUp:(id)sender
{
    UIButton *button = sender;
    NSUInteger index = button.tag;
    [_contentView setContentOffset:CGPointMake(index * SCREEN_WIDTH, 0) animated:YES];
}

- (void)subLoadContentView
{
    UIView *rootView = _contentView;
    
    __block UIView *leftPageView = nil;
    [_pageItems enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL * stop) {
        TabPageScrollViewPageItem *item = obj;
        
        UIView *pageView = [UIView new];
        [rootView addSubview:pageView];
        [pageView mas_makeConstraints:^(MASConstraintMaker *make){
            make.top.equalTo(rootView.mas_bottom);
            make.width.equalTo(rootView.mas_width);
            make.height.equalTo(rootView.mas_height);
            
            if(idx == 0){
                make.left.equalTo(rootView.mas_left);
            }else if(idx == _pageItems.count - 1){
                make.right.equalTo(rootView.mas_right);
            }
            if(idx > 0){
                make.left.equalTo(leftPageView.mas_right);
            }
        }];
        
        [pageView addSubview:item.tabView];
        [item.tabView mas_makeConstraints:^(MASConstraintMaker *make){
            make.edges.equalTo(pageView);
        }];
        leftPageView = pageView;
    }];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat width = scrollView.frame.size.width;
    int tabIndex = (scrollView.contentOffset.x + (0.5f * width)) / width;
    
    for(UIButton *button in _tabButtons){
        button.selected = NO;
    }
    UIButton *button = _tabButtons[tabIndex];
    button.selected = YES;
    
    [_indicatorView mas_remakeConstraints:^(MASConstraintMaker *make){
        make.width.equalTo(@(SCREEN_WIDTH / _pageItems.count / 3 * 2));
        make.bottom.equalTo(_separatorView.mas_top);
        make.height.equalTo(@2);
        
        make.centerX.equalTo(button.mas_centerX);
    }];
    [UIView animateWithDuration:0.3f animations:^{
        [self layoutIfNeeded];
    }];
    
    if (_delegate && [_delegate respondsToSelector:@selector(TabPageScrollView:didPageItemSelected:withTabIndex:)]) {
        [_delegate TabPageScrollView:self didPageItemSelected:_pageItems[tabIndex] withTabIndex:tabIndex];
    }
}

@end
