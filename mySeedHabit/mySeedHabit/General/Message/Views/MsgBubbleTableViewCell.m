//
//  MsgBubbleTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/18/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgBubbleTableViewCell.h"

#import <UIImageView+WebCache.h>
#import "UIImageView+CJFUIImageView.h"
#import <EMSDK.h>
#import "CJFTools.h"
#import <Masonry.h>
#import "SeedUser.h"
#import "UserManager.h"
#import "UIColor+CJFColor.h"

@interface MsgBubbleTableViewCell ()

// 消息的方向：接收 或 发送
@property (nonatomic, assign) EMMessageDirection direction;
// 会话类型
@property (nonatomic, assign) EMMessageBodyType chatType;

// 消息文本内容
@property (nonatomic, strong) UILabel *msgText;

@end

@implementation MsgBubbleTableViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        // cell的基本配置
        self.backgroundColor = RGBA(249, 249, 249, 1);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 创建头像控件
        _avatarView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_avatarView];
        
        // 创建昵称控件
        _nicknameView = [[UILabel alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_nicknameView];
        _nicknameView.font = [UIFont systemFontOfSize:12];
        _nicknameView.textColor = [UIColor lightGrayColor];
        
        // 创建气泡控件
        _bubbleView = [[UIView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_bubbleView];
        _bubbleView.layer.cornerRadius = 5;
        _bubbleView.layer.masksToBounds = YES;
        _bubbleView.backgroundColor = [UIColor colorWithHexString:UIMainColor alpha:1];
        
        // 创建文本消息显示控件
        self.msgText = [[UILabel alloc]initWithFrame:CGRectZero];
        self.msgText.font = [UIFont systemFontOfSize:14];
        self.msgText.textColor = [UIColor darkGrayColor];
        self.msgText.numberOfLines = 0;
        self.msgText.lineBreakMode = NSLineBreakByCharWrapping;
        self.msgText.adjustsFontSizeToFitWidth = YES;
        self.msgText.textColor = [UIColor whiteColor];
        
    }
    return self;
}


-(void)setModel:(EMMessage *)model {
    _model = model;
    
    // 获取消息方向
    self.direction = model.direction;
    
    // 获取或创建会话
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:model.conversationId type:_conversationType createIfNotExist:YES];
    
    // 显示图像
    NSString *avatarUrl = nil;
    NSString *nickname = nil;
    if (self.direction == EMMessageDirectionSend) {
        //        NSLog(@"EMMessageDirectionSend");
        SeedUser *currentUser = [UserManager manager].currentUser;
        avatarUrl = currentUser.avatar_small;
        nickname = currentUser.nickname;
    }else if (self.direction == EMMessageDirectionReceive) {
        //        NSLog(@"EMMessageDirectionReceive");
        avatarUrl = conversation.ext[@"avatar"];
        nickname = conversation.ext[@"nickname"];
    }
    [_avatarView lhy_loadImageUrlStr:avatarUrl placeHolderImageName:@"placeHolder.png" radius:40];
    
    // 显示昵称
    _nicknameView.text = nickname;
    
    // 获取消息体
    EMMessageBody *msgBody = model.body;
    
    switch (msgBody.type) {
        case EMMessageBodyTypeText: {
            
            //            NSLog(@"EMMessageBodyTypeText");
            
            EMTextMessageBody *textMsgBody = (EMTextMessageBody *)msgBody;
            self.msgText.text = textMsgBody.text;
            [_bubbleView addSubview:self.msgText];
            
        }
            
            break;
        case EMMessageBodyTypeImage: {
            
            NSLog(@"EMMessageBodyTypeImage");
            
        }
            
            break;
        case EMMessageBodyTypeVideo: {
            
            NSLog(@"EMMessageBodyTypeVideo");
            
        }
            
            break;
        case EMMessageBodyTypeLocation: {
            
            NSLog(@"EMMessageBodyTypeLocation");
            
        }
            
            break;
        case EMMessageBodyTypeVoice: {
            
            NSLog(@"EMMessageBodyTypeVoice");
            
        }
            
            break;
        case EMMessageBodyTypeFile: {
            
            NSLog(@"EMMessageBodyTypeFile");
            
        }
            
            break;
            
        default:
            break;
    }
    
    
    
}

// 1
-(void)layoutSubviews {
    
    UIEdgeInsets padding = UIEdgeInsetsMake(5, 10, 5, 10);
    CGFloat selfWidth = SCREEN_WIDTH;
    
    // 设置消息文本区的约束
    [_msgText mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bubbleView.mas_top).with.offset(5);
        make.right.equalTo(_bubbleView.mas_right).with.offset(-5);
        make.bottom.equalTo(_bubbleView.mas_bottom).with.offset(-5);
        make.left.equalTo(_bubbleView.mas_left).with.offset(5);
    }];
    
    if (self.direction == EMMessageDirectionSend) {
        //        NSLog(@"EMMessageDirectionSend");
        
        // 设置头像的约束
        [_avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        // 设置昵称的约束
        //        if (_conversationType != EMConversationTypeChat) {
        
        [_nicknameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-60);
            make.size.mas_equalTo(CGSizeMake(selfWidth*2/5, 20));
        }];
        _nicknameView.textAlignment = NSTextAlignmentRight;
        
        // 设置气泡的约束
        [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(padding.top + 25);
            make.right.equalTo(self.contentView.mas_right).with.offset(-60);
            //            make.left.equalTo(self.contentView.mas_left).with.offset(selfWidth*3/5/2);
            make.width.lessThanOrEqualTo(@(selfWidth*3/5));
        }];
        
        //        }
        
    }else if (self.direction == EMMessageDirectionReceive) {
        //        NSLog(@"EMMessageDirectionReceive");
        
        // 设置头像的约束
        [_avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        // 设置昵称的约束
        //        if (_conversationType != EMConversationTypeChat) {
        
        [_nicknameView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(60);
            make.size.mas_equalTo(CGSizeMake(self.contentView.frame.size.width*2/5, 20));
        }];
        _nicknameView.textAlignment = NSTextAlignmentLeft;
        
        // 设置气泡的约束
        [_bubbleView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(padding.top + 25);
            //            make.right.equalTo(self.contentView.mas_right).with.offset(-selfWidth*3/5/2);
            make.left.equalTo(self.contentView.mas_left).with.offset(60);
            make.width.lessThanOrEqualTo(@(selfWidth*3/5));
        }];
        
        //        }
        
    }
    
}





+(CGFloat)heightWithMsgModel: (EMMessage *)message {
    EMTextMessageBody *msgBody = (EMTextMessageBody *)message.body;
    CGFloat width = SCREEN_WIDTH * 3 / 5;
    CGFloat textHeight = [CJFTools heightWithString:msgBody.text width:width font:[UIFont systemFontOfSize:14.3]];
    return textHeight + 20 + 20 + 10;
}







- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
