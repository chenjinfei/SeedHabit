//
//  MsgChatViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/15/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MsgChatViewController.h"

#import "SeedUser.h"
#import "KeyboardObserved.h"

#import <EMSDK.h>
#import <Masonry.h>

@interface MsgChatViewController ()<UITextFieldDelegate>

// 输入区域
@property (strong, nonatomic) IBOutlet UIView *InputAreaView;
// 录音按钮
@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;
// 发送按钮
@property (strong, nonatomic) IBOutlet UIButton *sendBtn;
// 表情按钮
@property (strong, nonatomic) IBOutlet UIButton *expressionBtn;
// 输入消息内容
@property (strong, nonatomic) IBOutlet UITextField *msgContent;

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
    
    self.navigationItem.title = self.targetUser.nickname;
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
    
    [KeyboardObserved manager];
    
    [self.msgContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.msgContent.delegate = self;
    
    
}


-(void)textFieldDidChange: (UITextField *)textField {
    NSLog(@"%@", textField.text);
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    CGFloat kbHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    NSLog(@"%f", kbHeight);
    if ([KeyboardObserved manager].keyboardIsVisible) {
        NSLog(@"yes");
    }else {
        NSLog(@"no");
    }
    
    
    [self.InputAreaView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.view);
        //        make.top.mas_equalTo(self.view.mas_top).with.mas_offset(SCREEN_HEIGHT-kbHeight-41-64);
        make.bottom.mas_equalTo(self.view.mas_bottom).with.mas_offset(-(41+64+kbHeight));
        make.height.equalTo(@41);
        
    }];
}

// 键盘return按钮的响应方法
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.msgContent resignFirstResponder];
    return YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.msgContent resignFirstResponder];
}


/**
 *  发送消息
 */
-(void)sendMsg {
    
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"%@:发送的消息", from]];
    
    // 构建会话ID
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:self.targetUser.account type:EMConversationTypeChat createIfNotExist:YES];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversation.conversationId from:from to:self.targetUser.account body:body ext:nil];
    message.chatType = EMChatTypeChat;// 设置为单聊消息
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSLog(@"msgBody=%@, msgStatus=%d, conversationId=%@", aMessage.body, aMessage.status, aMessage.conversationId);
        }else {
            NSLog(@"%@", aError);
        }
        ULog(@"status=%d, to=%@, from=%@", aMessage.status, aMessage.to, aMessage.from);
    }];
    
    
}

@end
