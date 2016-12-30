//
//  FollowViewController.m
//  Gogo
//
//  Created by Thuong on 11/3/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "FollowViewController.h"
#import "FollowTableViewCell.h"
#import "UITableView+DragLoad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "Object.h"
#import "FollowModel.h"
@interface FollowViewController ()<UITableViewDelegate , UITableViewDataSource,UITableViewDragLoadDelegate>{
    NSMutableArray *results;
    int page;
}
@end

@implementation FollowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    page = 1;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    results = [[NSMutableArray alloc]init];
    [self getData];
    // Do any additional setup after loading the view.
}
-(void)getData{
    if(_isFollower){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/get-follower?page=1" , _userID];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                       fromJSONDictionary:responseObject
                                                    error:nil];
            if(object.code == 1){
                results = [MTLJSONAdapter modelsOfClass:[FollowModel class] fromJSONArray:object.result error:nil];
                page++;
                [self.tableView finishRefresh];
                [self.tableView reloadData];
                
            }
            else NSLog(@"%@" , object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }else{
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/get-follows?page=1" , _userID];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                       fromJSONDictionary:responseObject
                                                    error:nil];
            if(object.code == 1){
                results = [MTLJSONAdapter modelsOfClass:[FollowModel class] fromJSONArray:object.result error:nil];
                page++;
                [self.tableView finishRefresh];
                [self.tableView reloadData];
                
            }
            else NSLog(@"%@" , object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];

    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FollowTableViewCell"];
    FollowModel *follow = results[indexPath.row];
    cell.lblUsername.text = follow.name;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , follow.avatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.width * 5 /32;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return results.count;
}
#pragma mark - Drag delegate methods
- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self getData];
    page = 2;
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    //cancel refresh request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    if(_isFollower){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/get-follower?page=%d" , _userID , page];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                       fromJSONDictionary:responseObject
                                                    error:nil];
            if(object.code == 1){
                NSArray *array = [MTLJSONAdapter modelsOfClass:[FollowModel class] fromJSONArray:object.result error:nil];
                for(FollowModel *follow in array){
                    [results addObject:follow];
                }
                page++;
                [self.tableView finishRefresh];
                [self.tableView reloadData];
                
            }
            else NSLog(@"%@" , object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }else{
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/get-follows?page=%d" , _userID , page];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
            Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                       fromJSONDictionary:responseObject
                                                    error:nil];
            if(object.code == 1){
                NSArray *array = [MTLJSONAdapter modelsOfClass:[FollowModel class] fromJSONArray:object.result error:nil];
                for(FollowModel *follow in array){
                    [results addObject:follow];
                }
                page++;
                [self.tableView finishRefresh];
                [self.tableView reloadData];
                
            }
            else NSLog(@"%@" , object.message);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        
    }
    
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
