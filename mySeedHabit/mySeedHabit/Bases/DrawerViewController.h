//
//  DrawerViewController.h
//  myProject
//
//  Created by cjf on 7/29/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawerViewController : UIViewController


/**
 *  快速获取抽屉对象类DrawerViewController
 *
 *  @return DrawerViewController
 */
+(instancetype)shareDrawer;

/**
 *  抽屉类的构造方法
 *
 *  @param mainVc    主视图
 *  @param leftVc    左视图
 *  @param leftWidth 左视图的最大显示范围，也是主视图的最大右移距离
 *
 *  @return DrawerViewController
 */
+(instancetype)drawerWithMainVc: (UIViewController *)mainVc leftVc: (UIViewController *)leftVc leftWidth: (CGFloat)leftWidth;

/**
 *  展开左视图
 */
-(void)openLeftVc;

/**
 *  收起左视图
 */
-(void)closeLeftVc;

/**
 *  切换显示指定的视图控制器
 *
 *  @param viewController 目标视图控制器对象
 */
-(void)turnToViewController: (UIViewController *)viewController;

/**
 *  返回到初始界面状态
 */
-(void)backHome;


@end
