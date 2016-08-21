//
//  ProtocolViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ProtocolViewController.h"

@interface ProtocolViewController ()

{
    UIWebView *webView;
}

@end

@implementation ProtocolViewController

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
    
    self.navigationItem.title = @"用户使用协议";
    self.view.backgroundColor = RGB(255, 255, 255);
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    webView.backgroundColor = RGB(255, 255, 255);
    [self.view addSubview: webView];
    
}

/**
 *  加载数据
 */
-(void)loadData {
    
    NSString *urlStr = @"http://api.idothing.com/website/Question/userInfo.html";
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    [webView loadRequest:request];
    
    
}


@end
