//
//  MessageViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MessageViewController.h"

#import "ContactsViewController.h"

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    // 创建控制器视图
    [self buildView];
}


// 创建控制器视图
-(void)buildView {
    // 创建导航右按钮
    UIButton *addContactBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [addContactBtnView setImage:IMAGE(@"contacts_32.png") forState:UIControlStateNormal];
    [addContactBtnView setImage:IMAGE(@"contacts_32.png") forState:UIControlStateHighlighted];
    [addContactBtnView addTarget:self action:@selector(showContacts:) forControlEvents:UIControlEventTouchUpInside];
    addContactBtnView.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *addContactBtn = [[UIBarButtonItem alloc]initWithCustomView:addContactBtnView];
    self.navigationItem.rightBarButtonItems = @[addContactBtn];
    
}

// 导航右按钮响应方法
-(void)showContacts: (UIButton *)sender {
    ContactsViewController *conVc = [[ContactsViewController alloc]init];
    [self.navigationController pushViewController:conVc animated:YES];
}



@end
