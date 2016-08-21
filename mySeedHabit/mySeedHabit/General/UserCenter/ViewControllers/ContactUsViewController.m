//
//  ContactUsViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/20/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ContactUsViewController.h"

@interface ContactUsViewController ()

@end

@implementation ContactUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = RGB(255, 255, 255);
    self.navigationItem.title = @"联系我们";
    
    UIImageView *contactus = [[UIImageView alloc]initWithImage:IMAGE(@"contactus.png")];
    [self.view addSubview:contactus];
    contactus.frame = CGRectMake(0, 30, SCREEN_WIDTH, SCREEN_WIDTH*115/375);
    
}


@end
