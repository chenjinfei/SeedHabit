//
//  DrawerViewController.m
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "DrawerViewController.h"

@interface DrawerViewController ()
// 主视图
@property (nonatomic, strong) UIViewController *mainVc;
// 左视图
@property (nonatomic, strong) UIViewController *leftVc;
// 目标视图
@property (nonatomic, strong) UIViewController *targetVc;
// 左视图的最大显示范围
@property (nonatomic, assign) CGFloat leftWidth;
// 遮罩按钮
@property (nonatomic, strong) UIButton *coverBtn;

@end

@implementation DrawerViewController

/**
 *  快速获取抽屉对象类DrawerViewController
 *
 *  @return DrawerViewController
 */
+(instancetype)shareDrawer {
    return (DrawerViewController *)[UIApplication sharedApplication].keyWindow.rootViewController;
}

/**
 *  抽屉类的构造方法
 *
 *  @param mainVc    主视图
 *  @param leftVc    左视图
 *  @param leftWidth 左视图的最大显示范围，也是主视图的最大右移距离
 *
 *  @return DrawerViewController
 */
+(instancetype)drawerWithMainVc:(UIViewController *)mainVc leftVc:(UIViewController *)leftVc leftWidth: (CGFloat)leftWidth {
    
    DrawerViewController *drawerVc = [[DrawerViewController alloc]init];
    
    drawerVc.mainVc = mainVc;
    drawerVc.leftVc = leftVc;
    drawerVc.leftWidth = leftWidth;
    
    [drawerVc.view addSubview:leftVc.view];
    [drawerVc.view addSubview:mainVc.view];
    
    [drawerVc addChildViewController:leftVc];
    [drawerVc addChildViewController:mainVc];
    
    drawerVc.mainVc.view.layer.shadowColor = [UIColor blackColor].CGColor;
    drawerVc.mainVc.view.layer.shadowOffset = CGSizeMake(-2, 1);
    drawerVc.mainVc.view.layer.shadowRadius = 2;
    drawerVc.mainVc.view.layer.shadowOpacity = 0.1;
    
    drawerVc.leftVc.view.frame = CGRectMake(-drawerVc.leftWidth, drawerVc.leftVc.view.frame.origin.y, leftWidth, drawerVc.leftVc.view.frame.size.height);
    
    // 循环向所有的view添加屏幕边缘拖拽手势
    if ([drawerVc.mainVc isKindOfClass:[UITabBarController class]]) {
        for (UIViewController *childVc in drawerVc.mainVc.childViewControllers) {
            [drawerVc addEdgePanGestureRecognizerToView:childVc.view];
        }
    }else {
        [drawerVc addEdgePanGestureRecognizerToView:drawerVc.mainVc.view];
    }
    
    return drawerVc;
}

/**
 *  添加屏幕边缘拖拽手势
 *
 *  @param view 添加手势的目标对象view
 */
-(void)addEdgePanGestureRecognizerToView: (UIView *)view {
    UIScreenEdgePanGestureRecognizer *edgePanGes = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgePanGesAction:)];
    edgePanGes.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePanGes];
}

/**
 *  屏幕边缘拖拽手势的响应方法
 *
 *  @param edgePanGes 屏幕边缘拖拽手势对象
 */
-(void)edgePanGesAction: (UIScreenEdgePanGestureRecognizer *)edgePanGes {
    
    // 手势在X方向的移动偏移量
    CGFloat offsetX = [edgePanGes translationInView:edgePanGes.view].x;
    if (edgePanGes.state == UIGestureRecognizerStateChanged) {
        self.mainVc.view.frame = CGRectMake(MIN(offsetX, self.leftWidth), self.mainVc.view.frame.origin.y, self.mainVc.view.frame.size.width, self.mainVc.view.frame.size.height);
        self.leftVc.view.frame = CGRectMake(MIN(-self.leftWidth + offsetX, 0), self.leftVc.view.frame.origin.y, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height);
    }else if (edgePanGes.state == UIGestureRecognizerStateEnded || edgePanGes.state == UIGestureRecognizerStateCancelled) {
        if (self.mainVc.view.frame.origin.x > self.leftWidth * 0.5) {
            [self openLeftVc];
        }else {
            [self closeLeftVc];
        }
    }
    
}

/**
 *  展开左视图
 */
-(void)openLeftVc {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.mainVc.view.frame = CGRectMake(self.leftWidth, self.mainVc.view.frame.origin.y, self.mainVc.view.frame.size.width, self.mainVc.view.frame.size.height);
        self.leftVc.view.frame = CGRectMake(0, self.leftVc.view.frame.origin.y, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        if (self.coverBtn == nil) { // 必须判断遮罩按钮为nil时才进行创建，否则会引发异常
            self.coverBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            self.coverBtn.frame = self.mainVc.view.bounds;
            self.coverBtn.backgroundColor = [UIColor clearColor];
        }
        [self.mainVc.view addSubview:self.coverBtn];
        [self.coverBtn addTarget:self action:@selector(closeLeftVc) forControlEvents:UIControlEventTouchUpInside];
        
        UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesAction:)];
        [self.coverBtn addGestureRecognizer:panGes];
        
    }];
    
}

/**
 *  拖拽手势响应方法
 *
 *  @param panGes 拖拽手势对象
 */
-(void)panGesAction: (UIPanGestureRecognizer *)panGes {
    
    CGFloat offsetX = [panGes translationInView:panGes.view].x;
    CGFloat distance = self.leftWidth - ABS(offsetX);
    
    // 拖拽刚开始时禁止向右
    if (offsetX > 0) {
        return;
    }
    
    if (panGes.state == UIGestureRecognizerStateCancelled || panGes.state == UIGestureRecognizerStateEnded) {
        
        if (self.mainVc.view.frame.origin.x > self.leftWidth * 0.5) {
            [self openLeftVc];
        }else {
            [self closeLeftVc];
        }
        
    }else if (panGes.state == UIGestureRecognizerStateChanged) {
        
        self.mainVc.view.frame = CGRectMake(MAX(0, distance), self.mainVc.view.frame.origin.y, self.mainVc.view.frame.size.width, self.mainVc.view.frame.size.height);
        self.leftVc.view.frame = CGRectMake(MAX(-self.leftWidth, -self.leftWidth + distance), self.leftVc.view.frame.origin.y, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height);
        
    }
    
}

/**
 *  收起左视图
 */
-(void)closeLeftVc {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.mainVc.view.frame = CGRectMake(0, 0, self.mainVc.view.frame.size.width, self.mainVc.view.frame.size.height);
        self.leftVc.view.frame = CGRectMake(-self.leftWidth, self.leftVc.view.frame.origin.y, self.leftVc.view.frame.size.width, self.leftVc.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self.coverBtn removeFromSuperview];
        self.coverBtn = nil;
        
    }];
    
}

/**
 *  切换显示指定的视图控制器
 *
 *  @param viewController 目标视图控制器对象
 */
-(void)turnToViewController:(UIViewController *)viewController {
    
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:viewController];
    
    /// TODO: 定义一个与系统原生的返回按钮
    UIBarButtonItem *backHomeBtnItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(backHome)];
    nav.topViewController.navigationItem.leftBarButtonItem = backHomeBtnItem;
    
    self.targetVc = nav;
    
    [self.mainVc.view addSubview:nav.view];
    [self.mainVc addChildViewController:nav];
    
    [self closeLeftVc];
}

/**
 *  返回到初始界面状态
 */
-(void)backHome {
    
    [UIView animateWithDuration:0.25 animations:^{
        
        self.targetVc.view.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, self.targetVc.view.frame.origin.y, self.targetVc.view.frame.size.width, self.targetVc.view.frame.size.height);
        
    } completion:^(BOOL finished) {
        
        [self.targetVc.view removeFromSuperview];
        [self.targetVc removeFromParentViewController];
        self.targetVc = nil;
        
    }];
    
}

@end
