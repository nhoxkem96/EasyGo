//
//  MoreViewController.m
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MoreViewController.h"
#import "AFNetworking.h"
#import "SingleObject.h"
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HeaderView.h"
#import "ClassfiedViewController.h"
#import "SearchViewController.h"
#import "MyProfileViewController.h"
#import "UITableView+DragLoad.h"
#import "MoreTableViewCell2.h"
#import "Object.h"
#import "Classfieds.h"
@interface MoreViewController ()<UISearchBarDelegate,MyProfileDelegate,UITableViewDelegate , UITableViewDataSource,UITableViewDragLoadDelegate>{
    int pageClassfied;
}
@property int dem;
@property NSMutableArray *results;
@end
@implementation MoreViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    _dem = 0;
    pageClassfied = 2;
    [self getData];
    
    // Do any additional setup after loading the view.
    [self initSearchBar];

//    [[self tableView] setBounces:NO];
    
    UITapGestureRecognizer *tapGestureRecognizerUsername = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped)];
    tapGestureRecognizerUsername.numberOfTapsRequired = 1;
    [self.vUser addGestureRecognizer:tapGestureRecognizerUsername];
    self.vUser.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizerLogout = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(logoutTapped)];
    tapGestureRecognizerLogout.numberOfTapsRequired = 1;
    [self.vLogout addGestureRecognizer:tapGestureRecognizerLogout];
    self.vLogout.userInteractionEnabled = YES;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1]];
    [self setFont];
    
    [self.tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = YES;
    self.results = [[NSMutableArray alloc]init];
    [self getClassifieds];
}
-(void)setFont{
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblFollowing setFont: [_lblFollowing.font fontWithSize:[Utils fontSizeBig]]];
    [_lblFollower setFont: [_lblFollower.font fontWithSize:[Utils fontSizeBig]]];
    [_lblLogout setFont: [_lblLogout.font fontWithSize:[Utils fontSizeBig]]];
    [_btnRaoVat.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
}
-(void)getClassifieds{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/classified?page=1"];
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
#pragma mark - tapGesture tapped

-(void)usernameTapped{
    MyProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    vc.delegate = self;
    vc.myProfile = _myProfile;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)logoutTapped{
    NSString *old_fcm_token = [[NSUserDefaults standardUserDefaults]
                               stringForKey:@"fcm_token"];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat:@"http://easygo.com.vn/api/fcm/%@" , old_fcm_token];
    [manager DELETE:url parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@" , responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    NSURL *URL = [NSURL URLWithString:@"http:easygo.com.vn/api/user/logout"];
    AFHTTPSessionManager *manager2 = [AFHTTPSessionManager manager];
    [manager2.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager2 GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" ,responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    NSString *typeLogin = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"typeLogin"];
    if([typeLogin caseInsensitiveCompare:@"facebook"] == NSOrderedSame){
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
        [FBSDKAccessToken setCurrentAccessToken:nil];
    }
    else if([typeLogin caseInsensitiveCompare:@"google"] == NSOrderedSame){
        [[GPPSignIn sharedInstance] signOut];
    }
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"typeLogin"];
    [self.tabBarController setSelectedIndex:0];
    LoginViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    [self presentViewController:vc animated:YES completion:nil];
//    [self.navigationController pushViewController:vc animated:YES];
}

-(void)getData{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                            stringForKey:@"userID"];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@" , userID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        NSLog(@"%@" , object);
        if(object.code == 1){
            _myProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            NSLog(@"%@" , object.result);
            NSLog(@"%@" , _myProfile);
            NSString *linkAvatar = [NSString stringWithFormat:@"%@" , self.myProfile.avatar];

            [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                              placeholderImage:[UIImage imageNamed:@"1"]];
            self.lblUserName.text = self.myProfile.name;

        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)initSearchBar {
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm thông tin địa điểm";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
}
-(void)viewDidLayoutSubviews{
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar layoutIfNeeded];
    CALayer *vClassiedBorder = [CALayer layer];
    vClassiedBorder.frame = CGRectMake(0, self.vClassfied.frame.size.height - 0.3, self.vClassfied.frame.size.width,0.3);
    vClassiedBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.vClassfied.layer addSublayer:vClassiedBorder];
    
    CALayer *vUserBorder = [CALayer layer];
    vUserBorder.frame = CGRectMake(0, self.vUser.frame.size.height - 0.3, self.vUser.frame.size.width,0.3);
    vUserBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.vUser.layer addSublayer:vUserBorder];
    
    CALayer *vLogoutBorder = [CALayer layer];
    vLogoutBorder.frame = CGRectMake(0, self.vLogout.frame.size.height - 0.3, self.vLogout.frame.size.width,0.3);
    vLogoutBorder.backgroundColor = [UIColor lightGrayColor].CGColor;
    [self.vLogout.layer addSublayer:vLogoutBorder];
    
}
-(void)clickBtnRaoVat:(id)sender{
//    ClassfiedViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ClassfiedViewController"];
//    [self.navigationController pushViewController:vc animated:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)clickBtnUser:(id)sender {
    MyProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"MyProfileViewController"];
    vc.myProfile = _myProfile;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self initSearchBar];
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *firstTabNC = [[self.tabBarController viewControllers] objectAtIndex:1];
    SearchViewController *vc = (SearchViewController*)[[firstTabNC viewControllers] objectAtIndex:0];
    [vc setEditSearchBar];
}
#pragma  mark - myprofile delegate
-(void)changeAvatar:(UIImage *)image{
    self.imgAvatar.image = image;
}
-(void)changeName:(NSString *)name{
    self.lblUserName.text = name;
}
#pragma mark - tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    MoreTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:@"MoreTableViewCell2"];
    Classfieds *classFied = self.results[indexPath.row];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , classFied.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblTitle.text = classFied.title;
    cell.lblContent.text = classFied.content;
    NSDate *date = [NSDate date];
    double timestamp1 = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp1*1000);
    NSString *nameAuthor = [NSString stringWithFormat:@"%@", classFied.authorName];
    long long time =  timeInMilisInt64 - [classFied.created longLongValue];
    cell.lblPoster.text = [NSString stringWithFormat:@"Được đăng bởi %@ %lld ngày trước" ,nameAuthor ,time/86400000];
    cell.lblLocation.text = [NSString stringWithFormat:@"%@" , classFied.location];
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
    NSLog(@"section-%ld, row-%ld", (long)indexPath.section, (long)indexPath.row);
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
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/classified?page=%d" , pageClassfied];
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

@end
