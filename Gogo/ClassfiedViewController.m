//
//  ClassfiedViewController.m
//  Gogo
//
//  Created by Thuong on 10/26/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "ClassfiedViewController.h"
#import "UITableView+DragLoad.h"
#import "CustomIOSAlertView.h"
#import "AddClassfied.h"
#import "Object.h"
#import "Classfieds.h"
#import "AFNetworking.h"
#import "ClassFiedTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ClassfiedDetail.h"
@interface ClassfiedViewController ()<AddClassfiedDelegate,CustomIOSAlertViewDelegate,UITableViewDragLoadDelegate>{
    CustomIOSAlertView *alertView;
    int pageClassfied;
}
@property NSMutableArray *results;
@end

@implementation ClassfiedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self getClassifieds];
    pageClassfied = 2;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 200;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    alertView.closeOnTouchUpOutside = YES;
    self.results = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.translucent = NO;
    // Do any additional setup after loading the view.
    [self initSearchBar];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
}
- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm rao vặt";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
}
#pragma mark - searchBar delegate
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    NSString *loadNew = [NSString stringWithFormat:@"http:easygo.com.vn/api/classified?keyword=%@&page=1" , searchText];
    NSLog(@"%@" , loadNew);
    NSURL *URL = [NSURL URLWithString:[loadNew stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            NSArray *results = [MTLJSONAdapter modelsOfClass:[Classfieds class] fromJSONArray:object.result error:nil];
            self.results = results;
            [self.tableView reloadData];
            NSLog(@"success");
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    if([searchText  isEqual: @""]){
        [searchBar resignFirstResponder];
    }
}
-(void)getClassifieds{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/classified?keyword=&page=1"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            self.results = [MTLJSONAdapter modelsOfClass:[Classfieds class] fromJSONArray:object.result error:nil];
            [self.tableView finishRefresh];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}
#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ClassFiedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClassFiedTableViewCell"];
    Classfieds *classFied = self.results[indexPath.row];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , classFied.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblTitle.text = classFied.title;
    cell.lblContent.text = classFied.content;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ClassfiedDetail *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ClassfiedDetail class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height*300/568);
    Classfieds *_classfied = self.results[indexPath.row];
    
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , _classfied.authorAvatar];
    [detailView.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    detailView.lblTitle.text = _classfied.title;
    detailView.lblContent.text = _classfied.content;
    detailView.lblLocation.text = _classfied.location;
    double timestamp1 = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp1*1000);
    long long time =  timeInMilisInt64 - [_classfied.created longLongValue];
    NSString *tmp = [NSString stringWithFormat:@"%@" , _classfied.authorName];
    if(time/86400000 != 0){
        detailView.lblPoster.text = [NSString stringWithFormat:@"Được đăng bởi %@ %lld ngày trước",tmp , time/86400000];
    }
    else if(time/3600000 != 0){
        detailView.lblPoster.text = [NSString stringWithFormat:@"Được đăng bởi %@ %lld giờ trước",tmp , time/3600000];
    }
    else if(time/60000 != 0){
        detailView.lblPoster.text = [NSString stringWithFormat:@"Được đăng bởi %@ %lld phút trước",tmp ,time/60000];
    }
    else {
        detailView.lblPoster.text = [NSString stringWithFormat:@"Vừa được đăng bởi %@",tmp];
    }
    
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:detailView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView1, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView1 tag]);
        [alertView1 close];
    }];
    alertView.parentView.userInteractionEnabled = YES;
    [alertView setUseMotionEffects:true];
    [self.searchBar resignFirstResponder];
    [alertView show];
    
}
#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self getClassifieds];
    pageClassfied = 2;
}

- (void)dragTableRefreshCanceled:(UITableView *)tableView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishRefresh) object:nil];
}

- (void)dragTableDidTriggerLoadMore:(UITableView *)tableView
{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/classified?keyword=&page=%d" , pageClassfied];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            NSArray *array = [MTLJSONAdapter modelsOfClass:[Classfieds class] fromJSONArray:object.result error:nil];
            for(Classfieds *noti in array){
                [self.results addObject:noti];
            }
            pageClassfied++;
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


- (IBAction)clickBtnAdd:(id)sender {
    AddClassfied *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([AddClassfied class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 723/928 + 40);
    detailView.delegate = self;
    
    alertView = [[CustomIOSAlertView alloc] init];
    
    [alertView setContainerView:detailView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setTintColor:[UIColor whiteColor]];
    [alertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView1, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView1 tag]);
        [alertView1 close];
    }];
    alertView.parentView.userInteractionEnabled = YES;
    [alertView setUseMotionEffects:true];
    [alertView show];
    [alertView bringSubviewToFront:self.view];
    
}
-(void)clickBtnDangtin:(NSString *)title Content:(NSString *)content Location:(NSString *)location{
    NSLog(@"%@  %@  %@" , title , content , location);
    [alertView close];
    NSDictionary *params = @{
                             @"title":title,
                             @"content":content,
                             @"location":location
                             };
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager POST:@"http://easygo.com.vn/api/classified" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        [self getClassifieds];
        pageClassfied = 2;
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
