//
//  MessageViewController.m
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "MessageViewController.h"

#import "ContactsViewController.h"

#import <EMSDK.h>
#import "UIImage+CJFImage.h"

// 测试
#import "UIButton+CJFUIButton.h"
#import <UIImageView+WebCache.h>

@interface MessageViewController ()<EMChatManagerDelegate>

// 会话列表
@property (nonatomic, strong) NSMutableArray *conversationsArr;

@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
#pragma mark 接收信息
    // 注册消息回调
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    
}


-(void)viewWillAppear:(BOOL)animated {
    // 创建控制器视图
    [self buildView];
    
    
    [self loadData];
}


// 加载数据
-(void)loadData {
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSLog(@"内存中所有会话：%@", conversations);
    
    for (EMConversation *cs in conversations) {
        EMTextMessageBody *msgBody = (EMTextMessageBody *)cs.latestMessage.body;
        NSLog(@"未读信息条数：%d 条； 最新一条信息是：%@",cs.unreadMessagesCount, msgBody.text);
    }
    
    
}


-(NSMutableArray *)conversationsArr {
    if (!_conversationsArr) {
        _conversationsArr = [[NSMutableArray alloc]init];
    }
    return _conversationsArr;
}




// 创建控制器视图
-(void)buildView {
    
    // 创建导航右按钮
    UIButton *addContactBtnView = [UIButton buttonWithType:UIButtonTypeCustom];
    [addContactBtnView setImage:IMAGE(@"contacts_32.png") forState:UIControlStateNormal];
    [addContactBtnView setImage:IMAGE(@"contacts_32.png") forState:UIControlStateHighlighted];
    [addContactBtnView addTarget:self action:@selector(showContacts:) forControlEvents:UIControlEventTouchUpInside];
    addContactBtnView.frame = CGRectMake(0, 0, 25, 25);
    UIBarButtonItem *addContactBtn = [[UIBarButtonItem alloc]initWithCustomView:addContactBtnView];
    self.navigationItem.rightBarButtonItems = @[addContactBtn];
    
}

// 导航右按钮响应方法
-(void)showContacts: (UIButton *)sender {
    self.hidesBottomBarWhenPushed = YES;
    ContactsViewController *conVc = [[ContactsViewController alloc]init];
    [self.navigationController pushViewController:conVc animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}


// 收到消息的回调，带有附件类型的消息可以用 SDK 提供的下载附件方法下载（后面会讲到）
- (void)didReceiveMessages:(NSArray *)aMessages
{
    ULog(@"========= 收到新信息 ==============");
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



@end
