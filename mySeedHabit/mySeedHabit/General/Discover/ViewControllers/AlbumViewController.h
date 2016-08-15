//
//  AlbumViewController.h
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/10.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AlbumViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *dayNumber;
@property (strong, nonatomic) IBOutlet UILabel *insist;
@property (strong, nonatomic) IBOutlet UILabel *publish;
@property (strong, nonatomic) IBOutlet UILabel *author;

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *insistText;
@property (nonatomic, strong) NSString *publishText;
@property (nonatomic, strong) NSString *authorText;

@property (nonatomic, strong) NSString *mind_note;
@property (nonatomic, strong) NSString *imageUrl;

@end
