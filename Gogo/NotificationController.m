//
//  NotificationController.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "NotificationController.h"
#import "RTLabel.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "NotificationModel.h"
#import "LoginViewController.h"
#import "UITableView+DragLoad.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "UserProfileViewController.h"
#import "Utils.h"
@interface NotificationController ()<UITableViewDragLoadDelegate>

@end
int page;
@implementation NotificationController
- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)viewDidLoad {
    page = 0;
    [super viewDidLoad];
    [self getData];
    self.results = [[NSMutableArray alloc]init];
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:nil];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1]];
}
-(void)getData{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"%@", string);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications?page=1"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                             error:nil];
        if(object.code == 1){
            self.results = [MTLJSONAdapter modelsOfClass:[NotificationModel class] fromJSONArray:object.result error:nil];
            page++;
            [self.tableView finishRefresh];
            [self.tableView reloadData];
            
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}
 
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NotificationTableViewCell" forIndexPath:indexPath];
    NotificationModel *noti = self.results[indexPath.row];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , noti.image];
    [cell.imgUserAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    if(noti.status == 1){
        cell.contentView.backgroundColor = [UIColor whiteColor];
    }
    NSString * htmlString = noti.content;
    NSString *stringToLoad = [NSString stringWithFormat:@"<html> \n"
                              "<head> \n"
                              "<style type=\"text/css\"> \n"
                              "body {font-family: \"%@\"; font-size: %u;}\n"
                              "</style> \n"
                              "</head> \n"
                              "<body>%@</body> \n"
                              "</html>", @"HelveticaNeue", [Utils fontSizeNormal]+1, htmlString];
    NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[stringToLoad dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
    
    cell.lblNotification.attributedText = attrStr;
    
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.width * 3/16;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NotificationModel *noti = self.results[indexPath.row];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"%@" , access_token);
    
    if(noti.status == 0){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications/%@/seen",noti.iD];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
    }
    noti.status = 1;
    self.results[indexPath.row] = noti;
    [self.tableView reloadData];
    if(noti.user_id.length > 1){
        UserProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        vc.userID = noti.user_id;
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        vc.idPost = noti.post_id;
        NSLog(@"cxzc %@" , noti.comment_id);
        vc.commentID = noti.comment_id;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - Drag delegate methods

-(void)refreshViewController{
    [self getData];
    page = 2;
}
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
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications?page=%d" , page];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            NSArray *array = [MTLJSONAdapter modelsOfClass:[NotificationModel class] fromJSONArray:object.result error:nil];
            for(NotificationModel *noti in array){
                [self.results addObject:noti];
            }
            page++;
            NSLog(@"%d" , page);
            [self.tableView finishLoadMore];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}


@end
