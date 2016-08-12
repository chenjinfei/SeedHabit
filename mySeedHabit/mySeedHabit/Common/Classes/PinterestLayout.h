//
//  PinterestLayout.h
//  UILesson_UICollectionView
//
//  Created by cjf on 16/6/12.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PinterestLayout;

#pragma mark 制定协议，让代理执行方法计算出item的高度
@protocol PinterestLayoutDelegate <NSObject>

-(CGFloat)pinterestLayout: (PinterestLayout *)pinterestLayout heightOfItemAtIndexPath: (NSIndexPath *)indexPath;

@end

@interface PinterestLayout : UICollectionViewLayout

// 列数
@property (nonatomic, assign) NSUInteger numberOfColumns;
// 每个item的大小（宽度相同）
@property (nonatomic, assign) CGSize itemSize;
// 列间距
@property (nonatomic, assign) CGFloat interItemSpacing;
// 行间距
@property (nonatomic, assign) CGFloat lineItemSpacing;
// 分区边距
@property (nonatomic, assign) UIEdgeInsets sectionInset;

#pragma mark 设置代理属性
@property (nonatomic, assign) id<PinterestLayoutDelegate> delegate;

@end
