//
//  DiscoveTableViewCell.m
//  mySeedHabit
//
//  Created by lanou罗志聪 on 16/8/11.
//  Copyright © 2016年 Jinfei Chen. All rights reserved.
//

#import "DiscoveTableViewCell.h"
#import "UIImageView+CJFUIImageView.h"
#import "UIButton+CJFUIButton.h"
#import <Masonry.h>
#import <UIButton+WebCache.h>
#import "CJFTools.h"
#import "UIView+CJFUIView.h"
#import "UserManager.h"
#import "SeedUser.h"
#import "KeyboardObserved.h"

#import "AlbumViewController.h"
#import "TreeInfoViewController.h"
#import "PropsListViewController.h"
#import "DiscoverDetailViewController.h"
#import "UserCenterViewController.h"
#import "HabitJoinListViewController.h"

@interface DiscoveTableViewCell () <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *contentV;

// 图片
@property (nonatomic, assign) CGFloat imageHeight;
@property (nonatomic, assign) BOOL isImage;
// mind_note
@property (nonatomic, strong) UILabel *mind_note;
@property (nonatomic, assign) CGFloat noteHeight;
// 点赞View
@property (nonatomic, strong) UIView *propV;
@property (nonatomic, assign) BOOL isProp;
@property (nonatomic, assign) CGFloat propHeight;
// 评论
@property (nonatomic, strong) UILabel *comment;
@property (nonatomic, assign) CGFloat commentHeight;

// 创建btn
@property (nonatomic, strong) UIButton *propPortraitBtn;
// 存储 Btn
@property (nonatomic, strong) NSMutableArray *btnArr;
// 个数
@property (nonatomic, assign) int count;

// 当前用户
@property (nonatomic, strong) SeedUser *seedUser;

// 添加评论
@property (nonatomic, strong) NSString *mindNoteId;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSString *commentText;

@property (nonatomic, strong) UIScrollView *mainScrollView;

@end

@implementation DiscoveTableViewCell

#pragma mark 自定义控件
- (void)awakeFromNib {
    // Initialization code
    
    self.seedUser = [UserManager manager].currentUser;
    
    [self.avatarBtn addTarget:self action:@selector(avatarBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建habitNameBtn
    self.habit_name.userInteractionEnabled = YES;
    self.habitNameBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    self.habitNameBtn.frame = self.habit_name.bounds;
    [self.habit_name addSubview:self.habitNameBtn];
    [self.habitNameBtn addTarget:self action:@selector(habitPush:) forControlEvents:UIControlEventTouchUpInside];
    self.habitNameBtn.backgroundColor = [UIColor clearColor];
    
    // 背景View角
    self.backgroundV.layer.cornerRadius = 3;
    self.backgroundV.layer.masksToBounds = YES;
    
    self.backgroundColor = RGB(245, 245, 245);
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // 建立UIIMageView
    self.contentImageV = [[UIImageView alloc] init];
    [self.contentV addSubview:self.contentImageV];
    self.contentImageV.contentMode = UIViewContentModeScaleAspectFill;
//    self.contentImageV.clipsToBounds = YES;
    [self.contentImageV setClipsToBounds:YES];
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickImage)];
    [self.contentImageV addGestureRecognizer:singleTap];
    
    // 建立mind_noteLabel
    self.mind_note = [[UILabel alloc] init];
    [self.contentV addSubview:self.mind_note];
//    self.mind_note.backgroundColor = [UIColor blueColor];
    
    // 建立 PropV
    self.propV = [[UIView alloc] init];
    [self.contentV addSubview:self.propV];
//    self.propV.backgroundColor = [UIColor lightGrayColor];
    
    // 建立 commentV
    self.comment = [[UILabel alloc] init];
    [self.contentV addSubview:self.comment];
//    self.comment.backgroundColor = [UIColor redColor];
    
    // 创建 数组 储存 Btn
    self.btnArr = [[NSMutableArray alloc] init];
    
    // i6Plus （414-60(两边边距)） / 9 = 39.33
    // 每个按键大小固定 32 ,39.33 - 32 = 7.33（每个按键间隔）
    // i6 375  / 8
    // i5、i4 320    / 7
    
    // 判断应该放多少点赞头像
    if (SCREEN_WIDTH == 414) {
        self.count = 9;
    }
    else if (SCREEN_WIDTH == 375) {
        self.count = 8;
    }
    else {
        self.count = 7;
    }
    for (int i = 0; i < self.count; i++) {
        self.propPortraitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.propV addSubview:self.propPortraitBtn];
//        self.propPortraitBtn.backgroundColor = [UIColor yellowColor];
        self.propPortraitBtn.layer.cornerRadius = 16;
        self.propPortraitBtn.layer.masksToBounds = YES;
        
        // 分别给第一个和最后一个赋值
        if (i == 0) {
            [self.propPortraitBtn setBackgroundImage:[UIImage imageNamed:@"heart2_32.png"] forState:UIControlStateNormal];
        }
        else if (i == self.count-1) {
            self.propListBtn = self.propPortraitBtn;
            [self.propPortraitBtn setBackgroundImage:[UIImage imageNamed:@"omit_32.png"] forState:UIControlStateNormal];
            [self.propListBtn addTarget:self action:@selector(propsListPush:) forControlEvents:UIControlEventTouchUpInside];
        }
//        else
//            self.propInfoBtn = self.propPortraitBtn;
        // 每个按键的约束
        [self.propPortraitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(32, 32));
            make.top.mas_equalTo(self.propV.mas_top).offset(0);
            make.left.mas_equalTo(self.propV.mas_left).offset(20+(float)i*((float)(SCREEN_WIDTH-60)/self.count));
        }];
        // 吧按键存到数组
        [self.btnArr addObject:self.propPortraitBtn];
    }
//    static int i = 0;
//    NSLog(@"输出多少次%d", i);
//    i ++;
    
}


#pragma mark model 赋值

- (void)setNotes:(Notes *)notes {
    
    if (_notes != notes) {
        _notes = notes;
      
        if (self.usersArr) {
            // 坚持的天数
            self.check_in_time.text = [NSString stringWithFormat:@"%ld", (long)notes.check_in_times];
            self.check_in_time.text = [self.check_in_time.text stringByAppendingFormat:@"天"];
            
            // Note
            self.note = notes.note;
    
            
            // 时间转换
            // 用户发表时间
            if ([self.note valueForKey:@"add_time"]) {
                CJFTools *times = [CJFTools manager];
                self.add_time.text = [times revertTimeamp:[NSString stringWithFormat:@"%@", [self.note valueForKey:@"add_time"]] withFormat:@"MM-dd HH:mm"];
            }
            
            // 心情
            self.mind_note.text = [self.note valueForKey:@"mind_note"];
            self.mind_note.font = [UIFont systemFontOfSize:14];
            self.mind_note.textColor = [UIColor darkGrayColor];
            self.mind_note.adjustsFontSizeToFitWidth= YES; // 完全展示文字
            
            // 内容图片 -- 如果存在则执行
//            NSMutableArray *imageArr = [[NSMutableArray alloc] init];
            if ([self.note valueForKey:@"mind_pic_small"] && ![[self.note valueForKey:@"mind_pic_small"] isEqualToString: @""]) {
                    self.contentImageV.image = nil;
                    [self.contentImageV lhy_loadImageUrlStr:[self.note valueForKey:@"mind_pic_small"] placeHolderImageName:@"placeHolder.png" radius:0];
                    self.isImage = YES;
//                    [self.imageArr addObject:[self.note valueForKey:@"mind_pic_small"]];
            }
            else
                self.isImage = NO;
            NSLog( @"%@", self.imageArr);
            
            // 解析评论
            NSArray *commentArr = notes.comments;
            Note *note = notes.note;
            NSMutableString *text = [[NSMutableString alloc] init];
//            NSMutableAttributedString *textA = [[NSMutableAttributedString alloc] init];
            NSMutableArray *comId = [[NSMutableArray alloc] init];
            int count = 0;
            int textCount = 0;
            if (commentArr != nil && commentArr.count > 0) {
                for (Comments *com in commentArr) {
                    
                    // 存储 回复
                    [comId addObject:[NSString stringWithFormat:@"%@", [com valueForKey:@"id"]]];
                    
                    if ([com valueForKey:@"mind_note_id"] == [note valueForKey:@"id"]) {
                        NSString *userStr;
                        NSString *comStr;
                        NSString *textTest;
                        NSString *replyStr;
//                        NSAttributedString *userStrA;
//                        NSAttributedString *textTestA;
//                        NSAttributedString *replyStrA;
//                        NSAttributedString *nickNameA;
                        for (Users *users in self.usersArr) {
                            if ([com valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                                if ([comId containsObject:[com valueForKey:@"be_commented_id"]] && [com valueForKey:@"be_commented_id"] != NULL) {
                                    NSLog(@"回复");
                                    for (Comments *comR in commentArr) {
                                        if ([[NSString stringWithFormat:@"%@", [comR valueForKey:@"id"]] isEqualToString:[com valueForKey:@"be_commented_id"]]) {
                                            for (Users *model in self.usersArr) {
                                                if ([comR valueForKey:@"user_id"] == [model valueForKey:@"uId"]) {
                                                    replyStr = [NSString stringWithFormat:@"%@", model.nickname];
//                                                    replyStrA = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", model.nickname]];
                                                }
                                            }
                                        }
                                    }
                                    userStr = [NSString stringWithFormat:@"%@ 回复 %@ ", users.nickname, replyStr];
                                    comStr = [NSString stringWithFormat:@"%@", [com valueForKey:@"comment_text_content"]];
                                    textTest = [NSString stringWithFormat:@"%@:%@", userStr, comStr];
//                                    userStrA = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 回复 %@ ", nickNameA, replyStrA]];
//                                    textTestA = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@", userStrA, comStr]];
                                }
                                else {
                                    NSLog(@"没有回复");
                                    userStr = [NSString stringWithFormat:@"%@", users.nickname];
                                    comStr = [NSString stringWithFormat:@"%@", [com valueForKey:@"comment_text_content"]];
                                    textTest = [NSString stringWithFormat:@"%@:%@", userStr, comStr];
//                                    userStrA = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", nickNameA]];
//                                    textTestA = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@", userStrA, comStr]];
                                }
                                // 完全一模一样就就不添加到 text 当中
                                if([text rangeOfString:textTest].location == NSNotFound)//_roaldSearchText
                                {
                                    if (count>0) {
                                        [text appendFormat:@"\n"];
                                    }
                                    
                                    [text appendFormat:@"%@", textTest];
//                                    [textA appendAttributedString:textTestA];
                                }
                                count++;
                                textCount++;
                            }
                        }
                        NSLog(@"%d", self.isDetail);
                        if (!self.isDetail && textCount > 2) {
                            [text appendFormat:@"\n查看更多消息"];
                            break;
                        }
                    }
                }
            }
            
//            self.comment.attributedText = textA;
//            if (SCREEN_WIDTH == 320) {
                self.comment.font = [UIFont systemFontOfSize:14];
//            }
//            else if (SCREEN_WIDTH == 375) {
//                self.comment.font = [UIFont systemFontOfSize:16];
//            }
//            else {
//                self.comment.font = [UIFont systemFontOfSize:17];
//            }
            self.comment.textColor = [UIColor darkGrayColor];
            self.comment.text = text;
            self.comment.adjustsFontSizeToFitWidth = YES; // 完全展示评论
            self.commentNumber.text = [NSString stringWithFormat:@"%ld", commentArr.count];
           
            // 点赞个数
            self.propNumber.text = [NSString stringWithFormat:@"%@", [note valueForKey:@"prop_count"]];
            // 解析点赞
            NSArray *propsArr = notes.props;
            // 存储点赞头像
            NSMutableArray *mArr = [[NSMutableArray alloc] init];
            if (propsArr.count > 0) {
                // 有图片
                self.isProp = YES;
                if (propsArr.count < self.count-2) {
                    self.count = (int)propsArr.count;
                }
                // 存储点赞图片的id
                for (int i = 0; i < self.count-2; i++) {
                    Props *props = propsArr[i];
                    for (Users *users in self.usersArr) {
                        if ([props valueForKey:@"user_id"] == [users valueForKey:@"uId"]) {
                            [mArr addObject:users];
                        }
                    }
                }
                NSMutableArray *aaaa = [[NSMutableArray alloc] init];
                [aaaa removeAllObjects];
                for (int i = 0; i < propsArr.count; i++) {
                    if (i != 0 && i != self.count - 1) {
                        
                        // 如果 头像 图片 不重复 才附图
                        if (![aaaa containsObject:[NSURL URLWithString:[mArr[i - 1] valueForKey:@"avatar_small"]]]) {
                            [self.btnArr[i] setImageWithUrl:[NSURL URLWithString:[mArr[i - 1] valueForKey:@"avatar_small"]] placeHolderImage:nil radius:16 forState:UIControlStateNormal];
                            [aaaa addObject:[NSURL URLWithString:[mArr[i - 1] valueForKey:@"avatar_small"]]];
                            i--;
                        }
                    }
                    //当 个数 达到 ，不再遍历，退出循环
                    if (i == self.count-2) {
                        break;
                    }
                }
            }
            else {
                self.isProp = NO;
            }
        }
        
//        if (self.isImage != false && self.mind_note != nil && self.comment != nil && self.isProp != false) {
        
#pragma mark 自适应 cell 高度
        if (self.isImage) {
            self.contentImageV.hidden = NO;
            self.imageHeight = SCREEN_WIDTH - 20;
                [self.contentImageV mas_remakeConstraints:^(MASConstraintMaker *make) {
                    make.size.mas_equalTo(CGSizeMake(self.imageHeight, self.imageHeight));
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);
                    make.left.mas_equalTo(self.contentV.mas_left).with.offset(0);
                    // 如果心情点赞评论都没有，则图片直接约束 contentV 底部
                    if (self.mind_note.text.length == 0 && self.isProp == 0 && self.comment.text.length == 0) {
                        make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                    }
                    
                }];
            }
        else {
            self.imageHeight = 0;
            self.contentImageV.hidden = YES;
        }
            
        if (self.mind_note.text.length > 0) {
            self.mind_note.hidden = NO;
            self.mind_note.numberOfLines = 8;
            self.noteHeight = [AppTools heightWithString:self.mind_note.text width:SCREEN_WIDTH-60 font:[UIFont boldSystemFontOfSize:17]];
            
            [self.mind_note mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, self.noteHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(20);
                if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(10);
                }
                else
                    make.top.mas_equalTo(self.contentV.mas_top).with.offset(20);

                // 如果点赞评论都没有，则心情直接约束 contentV 底部
                if (self.isProp == 0 && self.comment.text.length == 0) {
                    make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                }
                
            }];
        }
        else {
            self.noteHeight = 0;
            self.mind_note.hidden = YES;
        }
            
        if (self.isProp) {
            self.propV.hidden = NO;
            // 固定高度，PropV 装载 点赞
            self.propHeight = 32.0; // 头像32+上下边距各15
            [self.propV mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-20, self.propHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(0);
                if (self.mind_note.text.length > 0) {
                    make.top.mas_equalTo(self.mind_note.mas_bottom).with.offset(15);
                }
                else if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(15);
                }
                
                // 如果没有评论，直接约束contentV底部
                if (self.comment.text.length == 0) {
                    make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                }
            }];
        }
        else {
            self.propV.hidden = YES;
            self.propHeight = 0;
        }
        
        if (self.comment.text.length > 0) {
            
            self.comment.hidden = NO;
            self.comment.numberOfLines = 0;
            self.commentHeight = [AppTools heightWithString:self.comment.text width:SCREEN_WIDTH-40 font:[UIFont boldSystemFontOfSize:17]];
            
            [self.comment mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH-60, self.commentHeight));
                make.left.mas_equalTo(self.contentV.mas_left).with.offset(20);
                make.bottom.mas_equalTo(self.contentV.mas_bottom).with.offset(-20);
                if (self.isProp) {
                    make.top.mas_equalTo(self.propV.mas_bottom).with.offset(15);
                }
                else if (self.mind_note.text.length > 0) {
                    make.top.mas_equalTo(self.mind_note.mas_bottom).with.offset(10);
                }
                else if (self.isImage) {
                    make.top.mas_equalTo(self.contentImageV.mas_bottom).with.offset(10);
                }
                
            }];
        }
        else{
            self.commentHeight = 0;
            self.comment.hidden = YES;
        }
//        NSLog(@"set: %f, %f, %f, %f", self.imageHeight, self.noteHeight, self.propHeight, self.commentHeight);
    }
    
}

- (CGFloat)Height {
//    NSLog(@"%f, %f, %f, %f", self.imageHeight, self.noteHeight, self.propHeight, self.commentHeight);
//    NSLog(@"%f", self.noteHeight+self.commentHeight+self.propHeight+self.imageHeight);
    
    if (self.isImage) {
        if (self.mind_note.text.length > 0) {
            if (self.isProp && self.comment.text.length > 0) {
                return self.imageHeight+self.noteHeight+self.propHeight+40+self.commentHeight;
            }
            else if (self.isProp > 0) {
                return self.imageHeight+self.noteHeight+self.propHeight+40;
            }
            else if (self.comment.text.length > 0) {
                return self.imageHeight+self.noteHeight+self.commentHeight+40;
            }
            else
                return self.imageHeight+self.noteHeight+40;
        }
        else {
            if (self.isProp && self.comment.text.length > 0) {
                return self.imageHeight+self.propHeight+40+self.commentHeight;
            }
            else if (self.isProp > 0) {
                return self.imageHeight+self.propHeight+40;
            }
            else if (self.comment.text.length > 0) {
                return self.imageHeight+self.commentHeight+40;
            }
            else
                return self.imageHeight+40;
        }
            
    }
    else if (self.mind_note.text.length > 0) {
        if (self.isProp && self.comment.text.length > 0) {
            return self.propHeight+40+self.commentHeight+self.noteHeight;
        }
        else if (self.isProp > 0) {
            return self.noteHeight+self.propHeight+40;
        }
        else if (self.comment.text.length > 0) {
            return self.noteHeight+self.commentHeight+40;
        }
        else
            return self.noteHeight+40;
    }
    else if (self.isProp) {
        return self.propHeight + 40;
    }
    else if (self.comment.text.length > 0) {
        return self.commentHeight+20;
    }
    else {
        return self.noteHeight+self.commentHeight+self.propHeight+self.imageHeight;
    }
    
}

- (void)setUsers:(Users *)users {
    
    if (_users != users) {
        _users = users;
        self.userId.text = users.nickname;
        [self.imageV lhy_loadImageUrlStr:users.avatar_small placeHolderImageName:@"placeHolder.png" radius:20];
    }
    
}

- (void)setHabits:(Habits *)habits {
    
    if (_habits != habits) {
        _habits = habits;
        NSString *str = [NSString stringWithFormat:@"坚持"];
        self.habit_name.text = [str stringByAppendingFormat:@"#%@#", habits.name];
    }
    
}

#pragma mark tableViewCell 响应方法
- (IBAction)albumPush:(id)sender {
    
    NSLog(@"%d", self.isDetail);
    
    UIViewController *currVC = [self.contentView getCurrentViewController];
    // 参数
    Note *note = self.notes.note;
    NSString *title = self.habits.name;
    NSString *author = self.users.nickname;
    
    // 时间戳转时间
    // 不需要 + 28800 转换格式的时候自动加减
    CJFTools *times = [CJFTools manager];
    NSString *curr = [times revertTimeamp:[NSString stringWithFormat:@"%@", [note valueForKey:@"add_time"]] withFormat:@"yyyy.MM.dd"];
    
    AlbumViewController *albumVC = [[AlbumViewController alloc] init];
    albumVC.publishText = curr;
    albumVC.authorText = [NSString stringWithFormat:@"by %@", author];
    albumVC.imageUrl = [note valueForKey:@"mind_pic_small"];
    albumVC.mind_note = [note valueForKey:@"mind_note"];
    albumVC.day = [NSString stringWithFormat:@"第%ld天", self.notes.check_in_times];
    albumVC.insistText = title;
    
    currVC.hidesBottomBarWhenPushed = YES;
    [currVC.navigationController pushViewController:albumVC animated:YES];
    if (!self.isDetail) {
         currVC.hidesBottomBarWhenPushed=NO;
    }
   
}
- (IBAction)treeInfoPush:(id)sender {
    
    UIViewController *currVC = [self.contentView getCurrentViewController];
    
    // 参数
    Note *note = self.notes.note;
    NSString *title = self.habits.name;
    
    currVC.hidesBottomBarWhenPushed=YES;
    TreeInfoViewController *treeInfoVC = [[TreeInfoViewController alloc] init];
    // 发表的用户
    treeInfoVC.user_id = [note valueForKey:@"user_id"];
    // 发表的用户的习惯
    treeInfoVC.habit_id = [note valueForKey:@"habit_id"];
    // 发表的用户的坚持
    treeInfoVC.treeTitle = title;
    [currVC.navigationController pushViewController:treeInfoVC animated:YES];
//    currVC.hidesBottomBarWhenPushed=NO;
    if (!self.isDetail) {
        currVC.hidesBottomBarWhenPushed=NO;
    }
}
- (void)propsListPush:(id)sender {
    
    UIViewController *currVC = [self.contentView getCurrentViewController];
    
    // 参数
    Note *note = self.notes.note;
    
    currVC.hidesBottomBarWhenPushed=YES;
    PropsListViewController *propsListVC = [[PropsListViewController alloc] init];
    
    // 发表的用户
    propsListVC.user_id = [self.seedUser valueForKey:@"uId"];
    propsListVC.mind_note_id = [note valueForKey:@"id"];
    
    [currVC.navigationController pushViewController:propsListVC animated:YES];
//    currVC.hidesBottomBarWhenPushed=NO;
    if (!self.isDetail) {
        currVC.hidesBottomBarWhenPushed=NO;
    }
}
- (void)avatarBtnAction:(id)sender {
    
    UIViewController *currVC = [self.contentView getCurrentViewController];
    
    // 参数
    
    UserCenterViewController *userVC = [[UserCenterViewController alloc] init];
    userVC.user = (SeedUser *)self.users;
    currVC.hidesBottomBarWhenPushed=YES;
    [currVC.navigationController pushViewController:userVC animated:YES];
//    currVC.hidesBottomBarWhenPushed=NO;
    if (!self.isDetail) {
        currVC.hidesBottomBarWhenPushed=NO;
    }
}
- (void)habitPush:(id)sender {
    
    UIViewController *currVC = [self.contentView getCurrentViewController];
    
    // 参数
     Note *note = self.notes.note;
    currVC.hidesBottomBarWhenPushed = YES;
    HabitJoinListViewController *joinVC = [[HabitJoinListViewController alloc] init];
//    joinVC.habit_idStr = [NSString stringWithFormat:@"%@", note habit_id];
    joinVC.habit_idStr = [note valueForKey:@"habit_id"];
    
    [currVC.navigationController pushViewController:joinVC animated:YES];
//    currVC.hidesBottomBarWhenPushed = NO;
    if (!self.isDetail) {
        currVC.hidesBottomBarWhenPushed=NO;
    }
}
#pragma mark 点赞 评论
- (IBAction)propBtnAction:(id)sender {
    
    UIButton *btn = sender;
    // 参数
    Note *note = self.notes.note;
    
    // 点赞
    if (btn.selected == NO) {
        // 点赞请求
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"mind_note_id":[note valueForKey:@"id"],
                                     @"user_id":self.seedUser.uId
                                     //      mind_note_id=18035359&user_id=1850878
                                     };
        [session POST:APIPropNote parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@", error);
        }];
        NSLog(@"点赞 成功");
    }
    else {
        // 取消点赞请求
        AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
        NSDictionary *parameters = @{
                                     @"mind_note_id":[note valueForKey:@"id"],
                                     @"user_id":self.seedUser.uId
                                     // mind_note_id=18035359&user_id=1850878
                                     };
        [session POST:APICancelProp parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error=%@", error);
        }];
        NSLog(@"取消 点赞");
    }

    btn.selected = !btn.selected;

    /*
     点赞
     http://api.idothing.com/zhongzi/v2.php/MindNote/propNote
     mind_note_id=18035359&user_id=1850878

     取消点赞
     http://api.idothing.com/zhongzi/v2.php/MindNote/cancelProp
     mind_note_id=18035359&user_id=1850878
     */
}
- (IBAction)commentBtnAction:(id)sender {
    
    Note *note = self.notes.note;
    //        hotTabelView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.mindNoteId = [note valueForKey:@"id"];
    
    [KeyboardObserved manager];
    [self createKeyboard];
    
}
// 弹出键盘
- (void)createKeyboard {
    
    UIViewController *currVC = [self getCurrentViewController];
    
    // 弹出键盘加一层 view 遮盖下面的视图的点击响应
    CGFloat kbHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    UIView *vi1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-40-kbHeight)];
    [currVC.view addSubview:vi1];
    vi1.tag = 11;
    
    UIView *vi2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 0, SCREEN_WIDTH, 0)];
    
    // 输入框
    //    UITextView *text = [[UITextView alloc] initWithFrame:CGRectInset(vi2.bounds, 0, 0)];
    UITextView *text =[[UITextView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 40)];
    text.layer.borderColor = [UIColor lightGrayColor].CGColor;
    text.inputAccessoryView = text;
    text.backgroundColor = [UIColor whiteColor];
    text.returnKeyType = UIKeyboardTypeTwitter;
    text.delegate = self;
    text.font = [UIFont boldSystemFontOfSize:15];
    [vi2 addSubview:text];
    [currVC.view.window addSubview:vi2];
    // 输入框成为第一响应者
    [text becomeFirstResponder];
    
    self.textView = text;
    
    // 输入框的表情和发送按钮
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [text addSubview:sendBtn];
    sendBtn.frame = CGRectMake(SCREEN_WIDTH-60, 5, 50, 30);
    sendBtn.backgroundColor = [UIColor lightGrayColor];
    [sendBtn setTintColor:[UIColor whiteColor]];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *smilingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [text addSubview:smilingBtn];
    smilingBtn.frame = CGRectMake(SCREEN_WIDTH-100, 5, 30, 30);
    [smilingBtn setImage:[UIImage imageNamed:@"Smiling_32.png"] forState:UIControlStateNormal];
    
}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    
//    UIViewController *currVC = [self getCurrentViewController];
//    
//    UIView *v = [currVC.view viewWithTag:11];
//    
//    if (v) {
//        [self.textView resignFirstResponder];
//        [v removeFromSuperview];
//    }
//    
//}
// 监听textView文字输入
- (void)textViewDidChange:(UITextView *)textView {
    
    self.commentText = textView.text;
    
}
// 点击return回收键盘
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    UIViewController *currVC = [self getCurrentViewController];
    
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        
        UIView *v = [currVC.view viewWithTag:11];
        [v removeFromSuperview];
        
        if (textView.text.length > 0) {
            [self loadCommentData];
        }
        return NO;
    }
    return YES;
}
// send按钮响应
- (void)sendAction {
    
    if (self.commentText.length > 0) {
        [self loadCommentData];
    }
    
}
// 发送评论请求
- (void)loadCommentData {
    
    // 取消输入框的第一响应者
    [self.textView resignFirstResponder];
    
    // 评论
    //    http://api.idothing.com/zhongzi/v2.php/MindNote/comment
    //    comment_text_content=%E8%B5%9E&mind_note_id=18917711&user_id=1878988
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    NSDictionary *parameters = @{
                                 @"comment_text_content":self.commentText,
                                 @"mind_note_id":self.mindNoteId,
                                 @"user_id":self.seedUser.uId
                                 };
    [session POST:@"http://api.idothing.com/zhongzi/v2.php/MindNote/comment" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //        [hotTabelView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
}

#pragma mark 详情图片 放大保存
- (void)onClickImage {
    
    UIViewController *currVC = [self getCurrentViewController];
    
    NSLog(@"onClickImage");
    currVC.navigationController.navigationBarHidden = YES;
    
    self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    [currVC.view addSubview:self.mainScrollView];
    self.mainScrollView.backgroundColor = [UIColor blackColor];
    self.mainScrollView.contentSize = CGSizeMake(0, 0);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.mainScrollView.bounds];
    
    [imageView lhy_loadImageUrlStr:[self.notes.note valueForKey:@"mind_pic_big"] placeHolderImageName:@"placeHolder.png" radius:0];
    
    [self.mainScrollView addSubview:imageView];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.center = self.mainScrollView.center;
    imageView.userInteractionEnabled = YES;
    
    self.mainScrollView.minimumZoomScale = 1;
    self.mainScrollView.maximumZoomScale = 3;
    self.mainScrollView.zoomScale = 1;
    self.mainScrollView.delegate = self;
    self.mainScrollView.bounces = NO;
    
    UITapGestureRecognizer *singleTap =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onClickScroll)];
    [self.mainScrollView addGestureRecognizer:singleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longAction:)];
    //    触发长按最小时间
    longPress.minimumPressDuration = 0.8;
    [imageView addGestureRecognizer:longPress];
    
}
- (void)onClickScroll {
    UIViewController *currVC = [self getCurrentViewController];
    
    [self.mainScrollView removeFromSuperview];
    currVC.navigationController.navigationBarHidden = NO;
}
- (void)longAction:(id)sender {
    
    UIViewController *currVC = [self getCurrentViewController];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"保存图片到相册" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UIImage *cacheImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.notes.note valueForKey:@"mind_pic_big"]];
        UIImageWriteToSavedPhotosAlbum(cacheImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"不保存" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action1];
    [alert addAction:action2];// 添加按钮到警示框上面
    
    [currVC presentViewController:alert animated:YES completion:nil];
    
}
#pragma mark 将图片保存到本地
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    NSString *message = @"呵呵";
    if (!error) {
        message = @"成功保存到相册";
    }else
    {
        message = [error description];
    }
    NSLog(@"message is %@",message);
    
}

#pragma mark 告诉缩放的是哪个 View
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return [scrollView.subviews objectAtIndex:0];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
