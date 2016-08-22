//
//  HelpCenterDetailViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "HelpCenterDetailViewController.h"

@interface HelpCenterDetailViewController ()

{
    UIWebView *webView;
}

@end

@implementation HelpCenterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [self loadData];
}

/**
 *  创建视图
 */
-(void)buildView {
    
    self.navigationItem.title = @"问题详情";
    self.view.backgroundColor = RGB(255, 255, 255);
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview: webView];
    
}

/**
 *  加载数据
 */
-(void)loadData {
    
    if (self.url) {
        NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [webView loadRequest:request];
    }
    
}


@end
