//
//  MindNotesReviewViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/12/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MindNotesReviewViewController.h"

#import "HabitReviewCollectionViewCell.h"
#import "MindNotesModel.h"
#import "HabitModel.h"

#import <MJRefresh.h>
#import "DiscoverDetailViewController.h"

// 导入布局类
#import "PinterestLayout.h"

@interface MindNotesReviewViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, PinterestLayoutDelegate>

@property (nonatomic, strong)UICollectionView *collectionView;

// 数据源
@property (nonatomic, strong)
NSMutableArray *dataArr;

@end

@implementation MindNotesReviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self buildView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    NSLog(@"%@", self.habitModel);
    [self loadData];
    
}


// 重写数据源的getter方法（懒加载）
-(NSMutableArray *)dataArr {
    if (_dataArr == Nil) {
        _dataArr = [[NSMutableArray alloc]init];
    }
    return _dataArr;
}


/**
 *  创建视图
 */
-(void)buildView {
    
    self.view.backgroundColor = VCBackgroundColor;
    self.navigationItem.title = @"历史回顾";
    
    PinterestLayout *flowLayout = [self buildPinterestLayout];
    // 创建UICollectionView对象
    self.collectionView = [[UICollectionView alloc]initWithFrame:[UIScreen mainScreen].bounds collectionViewLayout:flowLayout];
    self.collectionView.backgroundColor = VCBackgroundColor;
    [self.view addSubview:self.collectionView];
    
    // 设置collectionView的代理并遵守协议，然后实现协议方法
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    // 注册自定义的cell
    [self.collectionView registerClass:[HabitReviewCollectionViewCell class] forCellWithReuseIdentifier:@"HabitPreviewCell"];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.collectionView.mj_header = header;
    
}

/**
 *  加载数据
 */
-(void)loadData {
    
    if (self.dataArr != nil) {
        [self.dataArr removeAllObjects];
    }
    [self.dataArr addObjectsFromArray:self.habitModel.mind_notes];
    [self.collectionView.mj_header endRefreshing];
    
}


// 创建flowLayout的方法
-(PinterestLayout *)buildPinterestLayout {
    
    // 创建flowLayout对象
    PinterestLayout *flowLayout = [[PinterestLayout alloc]init];
    // 设置分区的空白处间距
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    // 设置列数
    flowLayout.numberOfColumns = 2;
    // 设置列间距
    flowLayout.interItemSpacing = 10;
    // 设置行间距
    flowLayout.lineItemSpacing = 10;
    CGFloat width = SCREEN_WIDTH - flowLayout.sectionInset.left - flowLayout.sectionInset.right - flowLayout.interItemSpacing * (flowLayout.numberOfColumns - 1);
    flowLayout.itemSize = CGSizeMake(width / flowLayout.numberOfColumns, 10); // 这里height没有用到所以任何数值在这里都无意义
    // 设置代理并遵守协议，然后实现相关协议方法
    flowLayout.delegate = self;
    return flowLayout;
    
}


#pragma mark CollectionView的代理方法

// 指定每个分区中item的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}

// 指定分区中的item内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    // 从重用池中获取自定义cell
    HabitReviewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HabitPreviewCell" forIndexPath:indexPath];
    // 初始化数据源并加载数据
    MindNotesModel *model = self.dataArr[indexPath.item];
    cell.model = model;
    
    return cell;
    
}

// 实现自定义PinterestLayout的协议方法
-(CGFloat)pinterestLayout:(PinterestLayout *)pinterestLayout heightOfItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat itemWidth = pinterestLayout.itemSize.width;
    
    // 计算item的高度
    CGFloat itemHeight = 0.0;
    itemHeight = itemWidth + 40;
    return itemHeight;
    
}

// 实现点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"object");
    DiscoverDetailViewController *dVc = [[DiscoverDetailViewController alloc]init];
    
    [self.navigationController pushViewController:dVc animated:YES];
    
}


@end
