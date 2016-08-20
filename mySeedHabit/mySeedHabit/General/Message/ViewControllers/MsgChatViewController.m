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
#import "NSString+CJFString.h"
#import "UIColor+CJFColor.h"
#import "UserManager.h"

#import <EMSDK.h>
#import <Masonry.h>
#import <MJRefresh.h>

#import "MsgChatTextTableViewCell.h"
#import "MsgChatTextReceiveTableViewCell.h"

#import "MsgBubbleTableViewCell.h"

@interface MsgChatViewController ()<EMChatManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

// 输入区域
@property (strong, nonatomic) IBOutlet UIView *InputAreaView;
// 录音按钮
@property (strong, nonatomic) IBOutlet UIButton *voiceBtn;
// 文件按钮
@property (strong, nonatomic) IBOutlet UIButton *fileBtn;
// 表情按钮
@property (strong, nonatomic) IBOutlet UIButton *expressionBtn;
// 输入消息内容
@property (strong, nonatomic) IBOutlet UITextField *msgContent;

// 发送信息区域的底部约束
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *bottomSpace;

@property (nonatomic, strong) UITableView *tableView;
// 聊天记录
@property (nonatomic, strong) NSMutableArray *chatRecordArr;

// 发送按钮
@property (nonatomic, strong) UIButton *sendBtn;

// 信息记录显示页数
@property (nonatomic, assign) NSInteger page;
@property (nonatomic, assign) NSInteger limit;

@end

@implementation MsgChatViewController




- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    self.page = 0;
    self.limit = 10;
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    // 将所有未读信息设为已读
    [self.conversation markAllMessagesAsRead];
    
    [self loadData];
    
    [self scrollToBottom];
    
}


// 滚动到tableView底部
-(void)scrollToBottom {
    unsigned long count = self.chatRecordArr.count;
    if (count>0) {
        NSIndexPath *lastIndex = [NSIndexPath indexPathForRow:count-1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastIndex atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        [self.view layoutIfNeeded];
    }
}


// 懒加载
-(UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-41) style:UITableViewStylePlain];
    }
    return _tableView;
}

-(NSMutableArray *)chatRecordArr {
    if ((!_chatRecordArr)) {
        _chatRecordArr = [[NSMutableArray alloc]init];
    }
    return _chatRecordArr;
}


// 加载聊天记录数据
-(void)loadData {
    
    if (self.targetUser) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:[NSString stringWithFormat:@"%@", self.targetUser.uId] type:EMConversationTypeChat createIfNotExist:YES];
        self.conversation.ext = @{
                                  @"avatar": self.targetUser.avatar_small,
                                  @"nickname": self.targetUser.nickname
                                  };
        NSLog(@"当前会话的拓展信息：%@", self.conversation.ext);
    }
    
    // 加载会话记录
    NSArray *tmpArr = [self.conversation loadMoreMessagesFromId:nil limit:500 direction:EMMessageSearchDirectionUp];
    
    //    [largeArray subarrayWithRange:NSMakeRange(0, 10)];
    
    
    [self.chatRecordArr removeAllObjects];
    
    
    //    NSLog(@"page: %ld, limit: %ld, totalCount: %ld", self.page * self.limit, self.limit, tmpArr.count);
    //    
    //    if (self.page * self.limit + 10 < tmpArr.count) {
    //        self.limit = 10;
    //    }else {
    //        self.limit = tmpArr.count - self.page * self.limit;
    //    }
    //    
    //    NSRange range = NSMakeRange(self.page * self.limit, self.limit);
    //    
    //    NSLog(@"%@", [tmpArr subarrayWithRange: range]);
    //    
    [self.chatRecordArr addObjectsFromArray:tmpArr];
    //
    //    if (self.limit < 10) {
    //        self.page = 0;
    //    }else {
    //        self.page ++;
    //    }
    
    [self.tableView.mj_header endRefreshing];
    
}


/**
 *  构建视图
 */
-(void)buildView {
    
    if (self.conversation) {
        self.navigationItem.title = self.conversation.ext[@"nickname"];
    }
    if (self.targetUser) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:[NSString stringWithFormat:@"%@", self.targetUser.uId] type:EMConversationTypeChat createIfNotExist:YES];
        self.navigationItem.title = self.conversation.ext[@"nickname"];
    }
    //    self.navigationItem.title = self.conversation.conversationId;
    self.view.backgroundColor = RGBA(249, 249, 249, 1);
    
    // 监听输入框
    [self.msgContent addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.msgContent.delegate = self;
    
    // 监听键盘改变
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    self.tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    //注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
    // 创建导航右按钮
    UIButton *rightBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtnView setImage:IMAGE(@"more_32.png") forState:UIControlStateNormal];
    [rightBtnView setImage:IMAGE(@"more_32.png") forState:UIControlStateHighlighted];
    [rightBtnView addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    rightBtnView.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:rightBtnView];
    self.navigationItem.rightBarButtonItems = @[rightBtn];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChatTextTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyBubbleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"MsgChatTextReceiveTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MyReceiveBubbleCell"];
    
    //    [self.tableView registerNib:[UINib nibWithNibName:@"MsgBubbleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"BubbleCell"];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.tableView.mj_header = header;
    
}

// 监听导航右按钮的响应事件
-(void)rightBtnAction: (UIButton *)sender {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle: UIAlertControllerStyleActionSheet];
    
    // 清空聊天记录
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"清空聊天记录" style:    UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        NSLog(@"清空聊天记录");
        
    }];
    
    // 加入黑名单
    UIAlertAction *blackListAction = [UIAlertAction actionWithTitle:@"加入黑名单" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"加入黑名单");
        
    }];
    
#pragma mark 生成图片
    // 生成图片
    UIAlertAction *buildImageAction = [UIAlertAction actionWithTitle:@"生成长图片" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        NSLog(@"生成长图片");
        // 把tableView的内容全部展开
        self.tableView.frame = CGRectMake(0, 0, self.tableView.contentSize.width, self.tableView.contentSize.height);
        UIGraphicsBeginImageContextWithOptions(self.tableView.contentSize, YES, 0.0);
        [self.tableView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *tmpImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        UIImageWriteToSavedPhotosAlbum(tmpImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        // 把tableView的frame复位
        self.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64-41);
        
    }];
    
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    
    [alertController addAction:deleteAction];
    [alertController addAction:blackListAction];
    [alertController addAction:cancelAction];
    
    [alertController addAction:buildImageAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}



// 指定回调方法
- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo
{
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    
}


-(void)textFieldDidChange: (UITextField *)textField {
    if ([NSString isValidateEmpty:textField.text] || [textField.text isEqualToString:@""]) {
        [self removeSendBtn];
    }else {
        [self buildSendBtn];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField {
    
}


// 监听键盘的frame即将改变的时候调用
- (void)keyboardWillChange:(NSNotification *)note{
    // 获得键盘的frame
    CGRect frame = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:5 animations:^{
        self.bottomSpace.constant = frame.size.height;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-64-41-frame.size.height);
        [self.InputAreaView layoutIfNeeded];
    }];
    [self scrollToBottom];
}

// 监听键盘隐藏
-(void)keyboardWillHide: (NSNotification *)notification {
    [UIView animateWithDuration:5 animations:^{
        self.bottomSpace.constant = 0;
        self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-64-41);
        [self.InputAreaView layoutIfNeeded];
    }];
    [self scrollToBottom];
}

// 监听键盘return按钮的点击
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.msgContent resignFirstResponder];
    return YES;
}

// 点击空白处收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.msgContent resignFirstResponder];
}


/**
 *  发送消息
 */
-(void)sendMsg {
    
    if ([NSString isValidateEmpty:self.msgContent.text]) {
        return;
    }
    
    // 收起键盘
    [self.msgContent resignFirstResponder];
    
    NSString *from = [[EMClient sharedClient] currentUsername];
    NSString *to = nil;
    if(self.targetUser) {
        self.conversation = [[EMClient sharedClient].chatManager getConversation:[NSString stringWithFormat:@"%@", self.targetUser.uId] type:EMConversationTypeChat createIfNotExist:YES];
    }
    to = [NSString stringWithFormat:@"%@", self.conversation.conversationId];
    
    // 构建会话
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:to type:EMConversationTypeChat createIfNotExist:YES];
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:[NSString stringWithFormat:@"%@", self.msgContent.text]];
    
    
    // 会话的拓展信息：头像和昵称
    NSDictionary *aExt = @{
                           @"avatar" : [UserManager manager].currentUser.avatar_small,
                           @"nickname" : [UserManager manager].currentUser.nickname
                           };
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversation.conversationId from:from to:to body:body ext:aExt];
    // 设置为单聊消息
    message.chatType = EMChatTypeChat;
    // 发送消息
    [[EMClient sharedClient].chatManager asyncSendMessage:message progress:nil completion:^(EMMessage *aMessage, EMError *aError) {
        if (!aError) {
            NSLog(@"msgBody=%@, msgStatus=%d, conversationId=%@", aMessage.body, aMessage.status, aMessage.conversationId);
            // 更新数据
            [self loadData];
            [self.tableView reloadData];
            [self scrollToBottom];
        }else {
            NSLog(@"%@", aError);
        }
        //        ULog(@"status=%d, to=%@, from=%@", aMessage.status, aMessage.to, aMessage.from);
    }];
    // 清空输入框
    self.msgContent.text = @"";
    
    
}

// 监听录音按钮
- (IBAction)addVoice:(UIButton *)sender {
    
}

// 监听表情按钮
- (IBAction)addExpression:(UIButton *)sender {
    
}

// 监听文件按钮
- (IBAction)addFile:(UIButton *)sender {
    
}

// 添加发送按钮
-(void)buildSendBtn {
    if (!self.sendBtn) {
        self.sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.sendBtn.frame = CGRectMake(SCREEN_WIDTH-40, 0, 40, 41);
        self.sendBtn.backgroundColor = RGBA(255, 255, 255, 1);
        [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
        [self.sendBtn setTitleColor:[UIColor colorWithHexString:UIMainColor alpha:1] forState:UIControlStateNormal];
        self.sendBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [self.sendBtn addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];
    }
    [self.InputAreaView addSubview:self.sendBtn];
}

// 删除发送按钮
-(void)removeSendBtn {
    [self.sendBtn removeFromSuperview];
    self.sendBtn = nil;
}


// 收到消息的回调，带有附件类型的消息可以用 SDK 提供的下载附件方法下载（后面会讲到）
- (void)didReceiveMessages:(NSArray *)aMessages
{
    NSLog(@"========= 收到新信息 ==============");
    for (EMMessage *message in aMessages) {
        EMMessageBody *msgBody = message.body;
        switch (msgBody.type) {
            case EMMessageBodyTypeText:
            {
                // 收到的文字消息
                EMTextMessageBody *textBody = (EMTextMessageBody *)msgBody;
                NSString *txt = textBody.text;
                NSLog(@"收到的文字是 txt -- %@",txt);
            }
                break;
            case EMMessageBodyTypeImage:
            {
                // 得到一个图片消息body
                EMImageMessageBody *body = ((EMImageMessageBody *)msgBody);
                NSLog(@"大图remote路径 -- %@"   ,body.remotePath);
                NSLog(@"大图local路径 -- %@"    ,body.localPath); // // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"大图的secret -- %@"    ,body.secretKey);
                NSLog(@"大图的W -- %f ,大图的H -- %f",body.size.width,body.size.height);
                NSLog(@"大图的下载状态 -- %u",body.downloadStatus);
                
                
                // 缩略图sdk会自动下载
                NSLog(@"小图remote路径 -- %@"   ,body.thumbnailRemotePath);
                NSLog(@"小图local路径 -- %@"    ,body.thumbnailLocalPath);
                NSLog(@"小图的secret -- %@"    ,body.thumbnailSecretKey);
                NSLog(@"小图的W -- %f ,大图的H -- %f",body.thumbnailSize.width,body.thumbnailSize.height);
                NSLog(@"小图的下载状态 -- %u",body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeLocation:
            {
                EMLocationMessageBody *body = (EMLocationMessageBody *)msgBody;
                NSLog(@"纬度-- %f",body.latitude);
                NSLog(@"经度-- %f",body.longitude);
                NSLog(@"地址-- %@",body.address);
            }
                break;
            case EMMessageBodyTypeVoice:
            {
                // 音频sdk会自动下载
                EMVoiceMessageBody *body = (EMVoiceMessageBody *)msgBody;
                NSLog(@"音频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"音频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在（音频会自动调用）
                NSLog(@"音频的secret -- %@"        ,body.secretKey);
                NSLog(@"音频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"音频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"音频的时间长度 -- %d"      ,body.duration);
            }
                break;
            case EMMessageBodyTypeVideo:
            {
                EMVideoMessageBody *body = (EMVideoMessageBody *)msgBody;
                
                NSLog(@"视频remote路径 -- %@"      ,body.remotePath);
                NSLog(@"视频local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"视频的secret -- %@"        ,body.secretKey);
                NSLog(@"视频文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"视频文件的下载状态 -- %u"   ,body.downloadStatus);
                NSLog(@"视频的时间长度 -- %d"      ,body.duration);
                NSLog(@"视频的W -- %f ,视频的H -- %f", body.thumbnailSize.width, body.thumbnailSize.height);
                
                // 缩略图sdk会自动下载
                NSLog(@"缩略图的remote路径 -- %@"     ,body.thumbnailRemotePath);
                NSLog(@"缩略图的local路径 -- %@"      ,body.thumbnailLocalPath);
                NSLog(@"缩略图的secret -- %@"        ,body.thumbnailSecretKey);
                NSLog(@"缩略图的下载状态 -- %u"      ,body.thumbnailDownloadStatus);
            }
                break;
            case EMMessageBodyTypeFile:
            {
                EMFileMessageBody *body = (EMFileMessageBody *)msgBody;
                NSLog(@"文件remote路径 -- %@"      ,body.remotePath);
                NSLog(@"文件local路径 -- %@"       ,body.localPath); // 需要使用sdk提供的下载方法后才会存在
                NSLog(@"文件的secret -- %@"        ,body.secretKey);
                NSLog(@"文件文件大小 -- %lld"       ,body.fileLength);
                NSLog(@"文件文件的下载状态 -- %u"   ,body.downloadStatus);
            }
                break;
                
            default:
                break;
        }
    }
    
    
    // 刷新数据
    [self loadData];
    [self.tableView reloadData];
    [self scrollToBottom];
    
    
}

#pragma mark 消息已送达回执
/*!
 @method
 @brief 接收到一条及以上已送达回执
 当对方收到您的消息后，您会收到以下回调
 */
- (void)didReceiveHasDeliveredAcks:(NSArray *)aMessages {
    NSLog(@"消息已送达！：%@", aMessages);
}



#pragma mark tableView的代理方法实现

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.chatRecordArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EMMessage *message = self.chatRecordArr[indexPath.row];
    
    //    NSString *cellIdentifier = nil;
    //    if ((int)message.direction == 0) {
    //        cellIdentifier = @"MyBubbleCell";
    //        MsgChatTextTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //        cell.model = self.chatRecordArr[indexPath.row];
    //        
    //        cell.backgroundColor = CLEARCOLOR;
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        return cell;
    //    }else {
    //        cellIdentifier = @"MyReceiveBubbleCell";
    //        MsgChatTextReceiveTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    //        cell.model = self.chatRecordArr[indexPath.row];
    //        
    //        cell.backgroundColor = CLEARCOLOR;
    //        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //        
    //        return cell;
    //    }
    
    MsgBubbleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BubbleCell"];
    if (!cell) {
        cell = [[MsgBubbleTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BubbleCell"];
    }
    
    cell.model = message;
    cell.conversationType = self.conversation.type;
    
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //        return 100;
    EMMessage *msg = self.chatRecordArr[indexPath.row];
    CGFloat height = [MsgBubbleTableViewCell heightWithMsgModel:msg];
    return height;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 收起键盘
    [self.msgContent resignFirstResponder];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}






@end
