//
//  Macros_API.h
//  myProject
//
//  Created by cjf on 7/30/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#ifndef Macros_API_h
#define Macros_API_h





// 基础API
#define APIURL                         @"http://api.idothing.com/zhongzi/v2.php/"


// 用户使用协议  GET
#define APIQuestion       @"http://api.idothing.com/website/Question/userInfo.html"



// == 用户API ==
#define APIUser                        [APIURL stringByAppendingString:@"User/"]

// 登录
#define APILogin                   [APIUser stringByAppendingString:@"login"]
// 退出登录
#define APILogout                   [APIUser stringByAppendingString:@"logout"]
// 用户信息更新
#define APIUserUpdate                  [APIUser stringByAppendingString:@"update"]
// 我的联系人、互相关注的好友列表
#define APIFollowedList                [APIUser stringByAppendingString:@"getFollowedList"]
// 搜索用户
#define APIUserSearch                  [APIUser stringByAppendingString:@"searchUser"]
// 精选用户、热门用户 推荐
#define APIRecommendChoiceUsers        [APIUser stringByAppendingString:@"recommendChoiceUsers"]
// 取消关注
#define APICancelFollow                [APIUser stringByAppendingString:@"cancelFollow"]
// 关注
#define APIFollowUser                  [APIUser stringByAppendingString:@"followUser"]
// 用户信息
#define APIUserInfo                    [APIUser stringByAppendingString:@"getUserInfo"]
// 设备编号
#define APIUserDeviceNumber            [APIUser stringByAppendingString:@"getUserDeviceNumber"]
// 检查手机号是否已经注册
#define APIIsTelExist                  [APIUser stringByAppendingString:@"checkTelExist"]
// 通过手机号码注册
#define APIRegisterWithTel             [APIUser stringByAppendingString:@"registerWithTel"]




// == 用户协议 ==
#define APIQuestionUserInfo     @"http://api.idothing.com/website/Question/userInfo.html"




// == 分享 ==
#define APIShare            [APIURL stringByAppendingString:@"Share/"]

// 分享内容
#define APIShareContent     [APIShare stringByAppendingString:@"getShareContent"]




// == 用户习惯 ==
#define APIHabit                   [APIURL stringByAppendingString:@"Habit/"]

// 用户习惯列表
#define APIHabitList               [APIHabit stringByAppendingString:@"getHabitList"]
// 习惯分类列表
#define APIHabitClassify           [APIHabit stringByAppendingString:@"habitClassify"]
// 加入习惯
#define APIJoinHabit               [APIHabit stringByAppendingString:@"joinHabit"]
// 删除习惯
#define APIQuitHabit               [APIHabit stringByAppendingString:@"quitHabit"]
// 设置私密习惯
#define APISetPrivateHabit         [APIHabit stringByAppendingString:@"setPrivateHabit"]
// 同步习惯分类
#define APIHabitSortSynchronize    [APIHabit stringByAppendingString:@"habitSortSynchronize"]
// 设置习惯
#define APISetupHabit              [APIHabit stringByAppendingString:@"setupHabit"]
// 搜索习惯
#define APISearchHabit             [APIHabit stringByAppendingString:@"searchHabit"]
// 精选习惯、热门习惯 推荐
#define APIRecommendChoiceHabits   [APIHabit stringByAppendingString:@"recommendChoiceHabits"]
// 习惯列表预览（无图）
#define APIHabitListPreview        [APIHabit stringByAppendingString:@"getHabitListPreview"]





// == 消息 ==
#define APIMessage         [APIURL stringByAppendingString:@"Message/"]

// 新消息
#define APIRegHX           [APIMessage stringByAppendingString:@"regHX"]





// == 通知 ==
#define APINotification        [APIURL stringByAppendingString:@"Notification/"]

// 新通知
#define APINoticeNew           [APINotification stringByAppendingString:@"getNoticeNew"]





// == 习惯动态 ==
#define APIMindNote          [APIURL stringByAppendingString:@"MindNote/"]

// 点赞列表
#define APIPropsList         [APIMindNote stringByAppendingString:@"getPropsList"]
// 所有热门习惯动态
#define APIAllHotNotes       [APIMindNote stringByAppendingString:@"listAllHotNotes"]
// 所有的最新习惯动态（通过时间）
#define APIAllNotesByTime    [APIMindNote stringByAppendingString:@"listAllNotesByTime"]
// 最新用户习惯动态
#define APIHabitNotesByTime  [APIMindNote stringByAppendingString:@"listHabitNotesByTime"]
// 所有的最新习惯动态（通过好友）
#define APIAllNotesByFriend  [APIMindNote stringByAppendingString:@"listAllNotesByFriend"]
// 用户习惯动态
#define APIUserNotes         [APIMindNote stringByAppendingString:@"listUserNotes"]
// 精选习惯动态
#define APIHabitChoiceNotes  [APIMindNote stringByAppendingString:@"listHabitChoiceNotes"]
// 所有的最新习惯动态
#define APIAllNoteByLast     [APIMindNote stringByAppendingString:@"listAllNoteByLast"]
// 取消点赞
#define APICancelProp        [APIMindNote stringByAppendingString:@"cancelProp"]
// 点赞
#define APIPropNote          [APIMindNote stringByAppendingString:@"propNote"]
// 种子树信息
#define APITreeInfo          [APIMindNote stringByAppendingString:@"getTreeInfo"]







// == 收藏 ==
#define APICollect              [APIURL stringByAppendingString:@"Collect/"]

// 添加收藏
#define APIAddCollection        [APICollect stringByAppendingString:@"addCollection"]
// 取消收藏
#define APICancelCollection     [APICollect stringByAppendingString:@"cancelCollection"]
// 收藏状态
#define APIIsCollected          [APICollect stringByAppendingString:@"isCollected"]





// == 签到 ==
#define APICheckIn           [APIURL stringByAppendingString:@"CheckIn/"]

// 获取最新签到
#define APILastWeekCheckIn   [APICheckIn stringByAppendingString:@"getLastWeekCheckIn"]





// == 【发现】精选/热门 ==
#define APIChoiceNote           [APIURL stringByAppendingString:@"ChoiceNote/"]

// 精选活动
#define APIChoiceNoteActivity   [APIChoiceNote stringByAppendingString:@"activity"]
// 广告图和习惯
#define APIBannersAndHabits     [APIChoiceNote stringByAppendingString:@"listBannersAndHabits"]





// == 文章 ==
#define APIArticle                  [APIURL stringByAppendingString:@"Article/"]

// 精选活动
#define APIAddArticleNote           [APIArticle stringByAppendingString:@"addArticleNote"]
// 取消文章评论的点赞
#define APICancelArticleNoteProp    [APIArticle stringByAppendingString:@"cancelArticleNoteProp"]
// 提交评论
#define APIArticleComment           [APIArticle stringByAppendingString:@"articleComment"]
// 文章评论点赞
#define APIPropArticleNote          [APIArticle stringByAppendingString:@"propArticleNote"]
// 列出文章（通过时间）
#define APIArticleNotesByTime       [APIArticle stringByAppendingString:@"listArticleNotesByTime"]
// 所有文章
#define APIHundredsOfNote           [APIArticle stringByAppendingString:@"getHundredsOfNote"]
// 新增文章共享
#define APIAddShareCount            [APIArticle stringByAppendingString:@"addShareCount"]
// 文章详情内容（GET请求）
#define APIArticleUrl               [APIArticle stringByAppendingString:@"loadArticleUrl?"]
// 文章详情内容请求地址示例：
/*
 http://api.idothing.com/zhongzi/v2.php/Article/loadArticleUrl?user_id=1122171&&habit_id=1675&&article_id=105&&article_type=1&&mind_note_id=18035359
 */







#endif /* Macros_API_h */








