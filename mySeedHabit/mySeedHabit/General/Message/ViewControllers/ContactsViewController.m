//
//  ContactsViewController.m
//  我的联系人
//  mySeedHabit
//
//  Created by cjf on 8/5/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "ContactsViewController.h"

#import "NSString+CJFString.h"
#import "UIImage+CJFImage.h"
#import "KeyboardObserved.h"
#import "UserManager.h"
#import "SeedUser.h"
#import <UIImageView+WebCache.h>
#import <EMSDK.h>

@interface ContactsViewController ()<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchResultsUpdating>

// 搜索框
@property (nonatomic, strong) UISearchController *searchController;
// 数据
@property (nonatomic, strong) NSMutableArray *searchList;
@property (nonatomic, strong) NSMutableArray *dataList;
// 表格视图
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation ContactsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
    
    
    
    
}

-(void)viewWillAppear:(BOOL)animated {
    // 加载数据
    [self loadData];
}

// 加载数据
-(void)loadData {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    //    num=-1&user_id=1850878
    NSDictionary *parameters = @{
                                 @"num": @-1,
                                 @"user_id": [UserManager manager].currentUser.uId
                                 };
    [session POST:APIFollowedList parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"yes = %@", responseObject[@"data"][@"users"]);
        [self.dataList removeAllObjects];
        for (NSDictionary *dict in responseObject[@"data"][@"users"]) {
            SeedUser *modelUser = [[SeedUser alloc]init];
            [modelUser setValuesForKeysWithDictionary:dict];
            [self.dataList addObject:modelUser];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error = %@", error);
    }];
}

// 懒加载
-(NSMutableArray *)searchList {
    if (!_searchList) {
        _searchList = [[NSMutableArray alloc]init];
    }
    return _searchList;
}

-(NSMutableArray *)dataList {
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

// 创建控制器视图
-(void)buildView {
    self.navigationItem.title = @"我的联系人";
    
    // 创建tableView
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT-40-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    // 搜索框
    self.searchController = [[UISearchController alloc]initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.hidesNavigationBarDuringPresentation = NO;
    self.searchController.searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    self.searchController.searchBar.delegate = self;
    self.searchController.searchResultsUpdater = self;
    [self.searchController.searchBar sizeToFit];
    [self.view addSubview:self.searchController.searchBar];
    
}

//设置区域的行数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchController.active) {
        return [self.searchList count];
    }else{
        return [self.dataList count];
    }
    //    return  self.dataList.count;
}

//返回单元格内容
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *flag=@"cellFlag";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:flag];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:flag];
    }
    SeedUser *user = [[SeedUser alloc]init];
    if (self.searchController.active) {
        user = self.searchList[indexPath.row];
    }else {
        user = self.dataList[indexPath.row];
    }
    
    [cell.textLabel setText:user.nickname];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:user.avatar_small] placeholderImage:IMAGE(@"placeHolder.png")];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SeedUser *user = [[SeedUser alloc]init];
    
    if (self.searchController.active) {
        
        NSString *searchText = [self.searchController.searchBar text];
        if ([NSString isValidateEmpty:searchText]) {
            NSLog(@"===== %@ ====", self.dataList[indexPath.row]);
            
            user = self.dataList[indexPath.row];
            
        }else {
            NSLog(@"===== %@ ====", self.searchList[indexPath.row]);
            
            user = self.searchList[indexPath.row];
            
        }
        
    }else {
        
        NSLog(@"===== %@ ====", self.dataList[indexPath.row]);
        user = self.dataList[indexPath.row];
    }
    
    EMTextMessageBody *body = [[EMTextMessageBody alloc] initWithText:@"要发送的消息"];
    NSString *from = [[EMClient sharedClient] currentUsername];
    
    // 构建会话ID
    NSString *conversationId = [NSString stringWithFormat:@"%@%@", from, user.account];
    EMConversation *conversation = [[EMClient sharedClient].chatManager getConversation:conversationId type:EMConversationTypeChat createIfNotExist:YES];
    
    //生成Message
    EMMessage *message = [[EMMessage alloc] initWithConversationID:conversation.conversationId from:from to:user.account body:body ext:nil];
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

// 输入框内容改变时的回调方法
-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    
    // 监听键盘弹出
    [self keyboardManager];
    
    NSString *searchString = [self.searchController.searchBar text];
    // 输入是否为空判断
    if ([NSString isValidateEmpty:searchString]) {
        return;
    }
    if (self.searchList!= nil) {
        [self.searchList removeAllObjects];
    }
    //过滤数据
    for (SeedUser *sUser in self.dataList) {
        if ([sUser.nickname rangeOfString:searchString].location != NSNotFound) {
            [self.searchList addObject:sUser];
        }
    }
    //刷新表格
    [self.tableView reloadData];
}

/**
 *  键盘的显示与隐藏的监听
 */
-(void)keyboardManager {
    // 键盘高度
    CGFloat keyboardHeight = [KeyboardObserved manager].keyboardFrame.size.height;
    if ([[KeyboardObserved manager] keyboardIsVisible]) {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-40-64-keyboardHeight);
        }];
    }else {
        [UIView animateWithDuration:0.25 animations:^{
            self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, self.tableView.frame.size.width, SCREEN_HEIGHT-40-64+keyboardHeight);
        }];
    };
}


@end
