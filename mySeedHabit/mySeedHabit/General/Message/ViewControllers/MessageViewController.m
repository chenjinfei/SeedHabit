//
//  MessageViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MessageViewController.h"

#import <EMSDK.h>

@interface MessageViewController ()

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)click:(id)sender {
    
    EMError *error = [[EMClient sharedClient] registerWithUsername:@"18617304711" password:@"1234567890"];
    if (error==nil) {
        NSLog(@"注册成功");
    }else {
        NSLog(@"%@", error);
    }
    
    error = [[EMClient sharedClient] loginWithUsername:@"18617304711" password:@"1234567890"];
    if (!error) {
        NSLog(@"登录成功");
    }else {
        NSLog(@"登录失败：%@", error);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
