//
//  PinterestLayout.m
//  UILesson_UICollectionView
//
//  Created by cjf on 16/6/12.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "PinterestLayout.h"

#pragma mark 添加延展
@interface PinterestLayout ()

// 保存每一列的高度
@property (nonatomic, strong) NSMutableArray *heightsOfColumnsArr;
// 保存每一个item的布局数据: frame
@property (nonatomic, strong) NSMutableArray *framesOfItemsArr;
// 保存item的总个数
@property (nonatomic, assign) NSUInteger numberOfItems;

@end

@implementation PinterestLayout

// 初始化所有数组
-(void)initAllArray {
    
    self.framesOfItemsArr = [[NSMutableArray alloc]init];
    self.heightsOfColumnsArr = [[NSMutableArray alloc]init];
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        NSNumber *number = [NSNumber numberWithFloat:self.sectionInset.top];
        [self.heightsOfColumnsArr addObject:number];
        
    }
    
}

// 求最小高度的列的列号
-(NSUInteger)indexOfMinHeightColumn {
    
    NSUInteger indexOfMinHeightColumn = 0;
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        CGFloat minItemHeight = [self.heightsOfColumnsArr[indexOfMinHeightColumn] floatValue];
        CGFloat currentItemHeight = [self.heightsOfColumnsArr[i] floatValue];
        if (currentItemHeight < minItemHeight) {
            indexOfMinHeightColumn = i;
        }
        
    }
    return indexOfMinHeightColumn;
    
}

// 求最大高度的列的列号
-(NSUInteger)indexOfMaxHeightColumn {
    
    NSUInteger indexOfMaxHeightColumn = 0;
    for (int i = 0; i < self.numberOfColumns; i++) {
        
        CGFloat maxItemHeight = [self.heightsOfColumnsArr[indexOfMaxHeightColumn] floatValue];
        CGFloat currentItemHeight = [self.heightsOfColumnsArr[i] floatValue];
        if (currentItemHeight > maxItemHeight) {
            indexOfMaxHeightColumn = i;
        }
        
    }
    return indexOfMaxHeightColumn;
    
}


// 计算所有item的布局: frame (此方法在布局显示之前被调用)
-(void)prepareLayout {
    
    [super prepareLayout];
    // 初始化全部数组
    [self initAllArray];
    // 获取所有item的个数(本例只有一个section)
    self.numberOfItems = [self.collectionView numberOfItemsInSection:0];
    // 对所有的item进行布局
    for (int i = 0; i < self.numberOfItems; i++) {
        
        NSUInteger indexOfMinHeightColumn = [self indexOfMinHeightColumn];
        // 1、计算item的x值
        CGFloat X = indexOfMinHeightColumn * self.interItemSpacing + self.sectionInset.left + self.itemSize.width * indexOfMinHeightColumn;
        // 2、计算item的y值
        CGFloat Y = [self.heightsOfColumnsArr[indexOfMinHeightColumn] floatValue] + self.lineItemSpacing;
        // 3、计算item的width
        CGFloat width = 0.0;
        width = self.itemSize.width;
        // 4、计算item的height
        CGFloat height = 0.0;
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        if (self.delegate && [self.delegate respondsToSelector:@selector(pinterestLayout:heightOfItemAtIndexPath:)]) {
            height = [self.delegate pinterestLayout:self heightOfItemAtIndexPath:indexPath];
        }
        // 5、生成frame，加入数组framesOfItemsArr
        UICollectionViewLayoutAttributes *attribute = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attribute.frame = CGRectMake(X, Y, width, height);
        [self.framesOfItemsArr addObject:attribute];
        // 6、更新列的高度数组
        CGFloat heightOfCurrentColumn = [self.heightsOfColumnsArr[indexOfMinHeightColumn] floatValue] + self.lineItemSpacing + height;
        // @(变量) <===> NSNumber numberWith...
        self.heightsOfColumnsArr[indexOfMinHeightColumn] = @(heightOfCurrentColumn);
        
    }
    
}

// 返回整个布局的contentSize（可滚动区域）
-(CGSize)collectionViewContentSize {
    
    CGSize contentSize = self.collectionView.contentSize;
    NSUInteger indexOfMaxHeightColumn = [self indexOfMaxHeightColumn];
    CGFloat maxHeight = [self.heightsOfColumnsArr[indexOfMaxHeightColumn] floatValue];
    contentSize.height = maxHeight + self.sectionInset.bottom;
    return contentSize;
    
}

// 返回所有item的布局属性: frame
-(NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    return self.framesOfItemsArr;
    
}

@end
