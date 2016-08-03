//
//  RegisterDataViewController.h
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterDataViewController : UIViewController

// 手机号码
@property (nonatomic, strong) NSNumber *account;
// 第三方平台用户信息
@property (nonatomic, strong) id userProfile;

@end
