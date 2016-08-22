//
//  NotesCollectionViewController.m
//  mySeedHabit
//
//  Created by cjf on 8/18/16.
//  Copyright © 2016 Jinfei Chen. All rights reserved.
//

#import "NotesCollectionViewController.h"

#import "SeedUser.h"
#import "UserManager.h"
#import "CJFNoteModel.h"
#import <MJRefresh.h>

#import "NotesCollectionListTableViewCell.h"

@interface NotesCollectionViewController ()

// 数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation NotesCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildView];
}

-(void)viewWillAppear:(BOOL)animated {
    
    [self loadData];
    
}

-(NSMutableArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSMutableArray alloc]init];
    }
    return _dataSource;
}


// 加载数据
-(void)loadData {
    
    [self.dataSource removeAllObjects];
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    SeedUser *currentUser = [UserManager manager].currentUser;
    
    NSDictionary *parameters = @{
                                 @"page" : @1,
                                 @"user_id" : currentUser.uId
                                 };
    [session POST:APICollectionByTime parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@", responseObject);
        for (NSDictionary *dict in responseObject[@"data"][@"notes"]) {
            CJFNoteModel *model = [[CJFNoteModel alloc]init];
            [model setValuesForKeysWithDictionary:dict];
            
            CJFNoteCtnModel *noteCtnModel = [[CJFNoteCtnModel alloc]init];
            [noteCtnModel setValuesForKeysWithDictionary:dict[@"note"]];
            
            CJFUserModel *userModel = [[CJFUserModel alloc]init];
            [userModel setValuesForKeysWithDictionary:dict[@"note"][@"user"]];
            noteCtnModel.user = userModel;
            
            CJFHabitModel *habitModel = [[CJFHabitModel alloc]init];
            [habitModel setValuesForKeysWithDictionary:dict[@"note"][@"habit"]];
            noteCtnModel.habit = habitModel;
            
            model.note = noteCtnModel;
            [self.dataSource addObject:model];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
        });
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"出错啦：%@", error);
    }];
    
}


// 创建视图
-(void)buildView {
    
    self.navigationItem.title = @"我的收藏";
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = RGBA(249, 249, 249, 1);
    
    [self.tableView registerNib:[UINib nibWithNibName:@"NotesCollectionListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"NoteColletionCell"];
    
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    // 隐藏时间
    header.lastUpdatedTimeLabel.hidden = YES;
    // 设置header
    self.tableView.mj_header = header;
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.dataSource.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotesCollectionListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoteColletionCell" forIndexPath:indexPath];
    
    CJFNoteModel *model = self.dataSource[indexPath.row];
    
    cell.model = model;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CJFNoteModel *model = self.dataSource[indexPath.row];
    
    return [NotesCollectionListTableViewCell heightWithModel: model];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 50;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.001;
}


/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 } else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

/*
 #pragma mark - Table view delegate
 
 // In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
 - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 // Navigation logic may go here, for example:
 // Create the next view controller.
 <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
 
 // Pass the selected object to the new view controller.
 
 // Push the view controller.
 [self.navigationController pushViewController:detailViewController animated:YES];
 }
 */

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
