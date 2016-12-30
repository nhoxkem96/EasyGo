//
//  UserTagViewController.m
//  Gogo
//
//  Created by Thuong on 11/16/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserTagViewController.h"
#import "Object.h"
#import "UITableView+DragLoad.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "AFNetworking.h"
#import "UserTag.h"
#import "UserTagTableViewCell.h"
@interface UserTagViewController ()<UITableViewDelegate , UITableViewDataSource,UITableViewDragLoadDelegate>{
    NSMutableArray *results;
    int page;
    NSMutableArray *arrayTag;
}
@property (weak, nonatomic) IBOutlet ASJTagsView *tagsView;
@end

@implementation UserTagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    page = 1;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    _tagsView.tagColorTheme = TagColorThemeDefault;
    arrayTag =[[NSMutableArray alloc]init];
    results = [[NSMutableArray alloc]init];
    [self getData];
    [self handleTagBlocks];
}
- (void)handleTagBlocks
{
    __weak typeof(self) weakSelf = self;
    [_tagsView setDeleteBlock:^(NSString *tagText, NSInteger idx)
     {
         NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
         UserTagTableViewCell *cell = (UserTagTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
         cell.imgCheck.hidden = YES;
         [weakSelf.tagsView deleteTagAtIndex:idx];
         [arrayTag removeObjectAtIndex:idx];
     }];
}
-(void)getData{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/tag-suggest?page=1"];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            results = [MTLJSONAdapter modelsOfClass:[UserTag class] fromJSONArray:object.result error:nil];
            page++;
            [self.tableView finishRefresh];
            [self.tableView reloadData];
            
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
#pragma mark - tableview
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTagTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserTagTableViewCell"];
    UserTag *userTag = results[indexPath.row];
    cell.lblUsername.text = userTag.name;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , userTag.avatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    if(userTag.check){
        cell.imgCheck.hidden = NO;
    }
    else cell.imgCheck.hidden = YES;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [UIScreen mainScreen].bounds.size.width *5/32;
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
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/tag-suggest?page=%d" , page];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            NSArray *array = [MTLJSONAdapter modelsOfClass:[UserTag class] fromJSONArray:object.result error:nil];
            for(UserTag *userTag in array){
                [results addObject:userTag];
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

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UserTag *userTag = results[indexPath.row];
    UserTagTableViewCell *cell = (UserTagTableViewCell *)[_tableView cellForRowAtIndexPath:indexPath];
    if(userTag.check){
        for(int i = 0 ; i < arrayTag.count;i++){
            if([userTag.iD caseInsensitiveCompare:arrayTag[i]] == NSOrderedSame){
                [arrayTag removeObjectAtIndex:i];
                [self.tagsView deleteTagAtIndex:i];
            }
        }
        userTag.check = NO;
        cell.imgCheck.hidden = YES;
    }
    else{
        [arrayTag addObject:userTag.iD];
        [self.tagsView addTag:userTag.name];
        cell.imgCheck.hidden = NO;
        userTag.check = YES;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickBtnRightButton:(id)sender {
    if ([self.delegate respondsToSelector:@selector(clickBtnRightBarButton:)]) {
        [self.delegate clickBtnRightBarButton:arrayTag];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
