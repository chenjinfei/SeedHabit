//
//  NotesCollectionListTableViewCell.m
//  mySeedHabit
//
//  Created by cjf on 8/18/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "NotesCollectionListTableViewCell.h"

#import "CJFNoteModel.h"
#import "UIImageView+CJFUIImageView.h"
#import "UIButton+CJFUIButton.h"
#import "UIColor+CJFColor.h"
#import "CJFTools.h"
#import "NSString+CJFString.h"
#import <UIImageView+WebCache.h>
#import <Masonry.h>

@interface NotesCollectionListTableViewCell ()

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *whiteBgHeightConstraint;


@end

@implementation NotesCollectionListTableViewCell

-(void)setModel:(CJFNoteModel *)model {
    
    _model = model;
    
    self.clipsToBounds = YES;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    _whiteBgView.clipsToBounds = YES;
    // 白色背景的高度
    CGFloat whiteBgHeight = 0;
    
    UIView *superView = _whiteBgView;
    
    NSURL *avatarUrl = [NSURL URLWithString:model.note.user.avatar_small];
    [_avatarView setImageWithUrl:avatarUrl placeHolderImage:IMAGE(@"placeHolder.png") radius:75 forState:UIControlStateNormal];
    
    // 配置头像约束
    [_avatarView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(10);
        make.left.equalTo(superView.mas_left).with.mas_offset(10);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    _pubTimeView.text = [[CJFTools manager] revertTimeamp:[NSString stringWithFormat:@"%ld", model.add_time] withFormat:@"YY/MM/dd"];
    
    // 配置发布时间约束
    [_pubTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(10);
        make.right.equalTo(superView.mas_right).with.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    _holdTimeView.text = [NSString stringWithFormat:@"%ld天", model.note.check_in_times];
    
    // 配置坚持时间约束
    [_holdTimeView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_pubTimeView.mas_bottom).with.mas_offset(0);
        make.right.equalTo(superView.mas_right).with.mas_offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    _nicknameView.text = model.note.user.nickname;
    
    // 配置昵称约束
    [_nicknameView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.mas_offset(10);
        make.left.equalTo(_avatarView.mas_right).with.mas_offset(10);
        make.right.equalTo(_pubTimeView.mas_left).with.mas_offset(0);
        make.height.mas_equalTo(20);
    }];
    
    NSString *habitStr = [NSString stringWithFormat:@"坚持#%@#", model.note.habit.name];
    NSMutableAttributedString *habitName = [[NSMutableAttributedString alloc]initWithString:habitStr];
    [habitName addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:UIMainColor alpha:1] range:NSMakeRange(2, habitStr.length-2)];
    _subTitleView.attributedText = habitName;
    
    // 配置坚持的习惯约束
    [_subTitleView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_nicknameView.mas_bottom).with.mas_offset(0);
        make.right.equalTo(_holdTimeView.mas_left).with.mas_offset(0);
        make.left.equalTo(_avatarView.mas_right).with.mas_offset(10);
        make.height.mas_equalTo(20);
    }];
    
    whiteBgHeight += 60;
    
    CGFloat noteCtnHeight = 0;
    
    if (!model.note.mind_note || [model.note.mind_note isEqualToString:@""]) {
        if (_noteCtnView) {
            [_noteCtnView removeFromSuperview];
            _noteCtnView = nil;
        }
    }else {
        if(!_noteCtnView){
            _noteCtnView = [[UILabel alloc]init];
        }
        [self.contentView addSubview:_noteCtnView];
        
        _noteCtnView.text = model.note.mind_note;
        
        _noteCtnView.numberOfLines = 0;
        _noteCtnView.lineBreakMode = NSLineBreakByWordWrapping;
        _noteCtnView.font = [UIFont systemFontOfSize:14];
        _noteCtnView.textColor = [UIColor darkGrayColor];
        _noteCtnView.adjustsFontSizeToFitWidth = YES;
        
        noteCtnHeight = [CJFTools heightWithString:model.note.mind_note width:SCREEN_WIDTH-70 font:[UIFont systemFontOfSize:14]];
        if (noteCtnHeight < 20) {
            noteCtnHeight = 20;
        }
        
    }
    
    if (model.note.mind_pic_small != nil) {
        
        _picView.hidden = NO;
        _picView.clipsToBounds = YES;
        [_picView setContentMode:UIViewContentModeScaleAspectFill];
        
        NSURL *notePicUrl = [NSURL URLWithString:model.note.mind_pic_small];
        [_picView sd_setImageWithURL:notePicUrl placeholderImage:IMAGE(@"placeHolder.png")];
        
        // 配置心情图片约束
        [_picView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(superView.mas_top).with.mas_offset(60);
            make.right.equalTo(superView.mas_right).with.mas_offset(0);
            make.left.equalTo(superView.mas_left).with.mas_offset(0);
            make.height.mas_equalTo(_picView.mas_width);
        }];
        
        if (model.note.mind_note != nil) {
            
            // 配置心情文字的约束
            [_noteCtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView.mas_top).with.mas_offset(60 + SCREEN_WIDTH - 10);
                make.right.equalTo(superView.mas_right).with.mas_offset(-15);
                make.left.equalTo(superView.mas_left).with.mas_offset(15);
                make.height.equalTo(@(noteCtnHeight+5));
            }];
            
            whiteBgHeight += (SCREEN_WIDTH - 16 + noteCtnHeight + 20);
            
        }else {
            
            whiteBgHeight += (SCREEN_WIDTH - 16);
            
        }
        
    }else {
        
        _picView.hidden = YES;
        
        if (model.note.mind_note != nil) {
            
            // 配置心情文字的约束
            [_noteCtnView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(superView.mas_top).with.mas_offset(60);
                make.right.equalTo(superView.mas_right).with.mas_offset(-15);
                make.left.equalTo(superView.mas_left).with.mas_offset(15);
                make.height.equalTo(@(noteCtnHeight+5));
            }];
            
            whiteBgHeight += (noteCtnHeight + 20);
            
        }
        
    }
    
    // 配置白色背景的约束
    self.whiteBgHeightConstraint.constant = whiteBgHeight;
    
}


// 计算图片高度的方法
-(CGFloat)imageHeightWithUrl: (NSURL *)url {
    NSData *imgData = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:imgData];
    return image.size.height;
}



// 计算cell自身的高度
+(CGFloat)heightWithModel: (CJFNoteModel *)model {
    
    CGFloat height = 0;
    if (model.note.mind_note != nil) {
        height = [CJFTools heightWithString:model.note.mind_note width:SCREEN_WIDTH-40 font:[UIFont systemFontOfSize:14]];
        if (height < 20) {
            height = 20;
        }
    }
    
    if (model.note.mind_pic_small != nil && model.note.mind_note != nil) {
        if ([NSString isValidateEmpty:model.note.mind_note]) {
            return 20 + 60 + (SCREEN_WIDTH - 20) + 12;
        }else {
            return 20 + 60 + (SCREEN_WIDTH - 20) + height + 12;
        }
    }
    
    if ( model.note.mind_pic_small == nil && model.note.mind_note != nil) {
        
        return 20 + 60 + height + 12;
        
    }
    
    return 20 + 60 + 20;
    
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    [_noteCtnView removeConstraints:_noteCtnView.constraints];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
