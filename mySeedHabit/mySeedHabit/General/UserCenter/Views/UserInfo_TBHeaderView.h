//
//  UserInfo_TBHeaderView.h
//  mySeedHabit
//
//  Created by cjf on 8/9/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfo_TBHeaderView : UIView

@property (strong, nonatomic) IBOutlet UIImageView *avatarView;
@property (strong, nonatomic) IBOutlet UILabel *habitCountView;
@property (strong, nonatomic) IBOutlet UILabel *followCountView;
@property (strong, nonatomic) IBOutlet UILabel *followerCountView;
@property (strong, nonatomic) IBOutlet UILabel *signatureView;



@end
