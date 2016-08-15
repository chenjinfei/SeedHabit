//
//  MsgChatViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/15/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgChatViewController.h"

#import "SeedUser.h"

@interface MsgChatViewController ()

@end

@implementation MsgChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self buildView];
    
}


/**
 *  构建视图
 */
-(void)buildView {
    
    self.navigationItem.title = self.toUser.nickname;
    
}

@end
