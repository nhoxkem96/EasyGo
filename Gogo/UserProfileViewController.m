//
//  UserProfileViewController.m
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "UserProfileViewController.h"
#import "AFNetworking.h"
#import "UserProfileTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "SingleObject.h"
#import "ImageGroup.h"
#import "ViewController.h"
#import "LoginViewController.h"
#import "Utils.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "UITableView+DragLoad.h"
#import "ReportView.h"
#import "CustomIOSAlertView.h"
#import "FollowViewController.h"
@interface UserProfileViewController ()<UserProfileTableViewCellDelegate,UITableViewDragLoadDelegate,ReportViewDelegate,CustomIOSAlertViewDelegate>{
    int numberData;
    CustomIOSAlertView *alertView;
    NSInteger cellReport;
}
@property NSMutableArray *results;
@property Object *object;
@property UserTimeline *timeline;
@end

@implementation UserProfileViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    numberData = 0;
    // Do any additional setup after loading the view.
    
    self.imgAvatarUser.layer.cornerRadius = self.imgAvatarUser.frame.size.height / 2;
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.navigationItem.backBarButtonItem setTitle:@" "];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 250;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
    [_tableView setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    _tableView.showRefreshView = NO;

    self.tableView.estimatedSectionHeaderHeight = 50; // for header
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self setFont];
    [self addTapgesture];
}
-(void)addTapgesture{
    UITapGestureRecognizer *tapGestureRecognizerFollower = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerTapped)];
    tapGestureRecognizerFollower.numberOfTapsRequired = 1;
    [self.lblFollower addGestureRecognizer:tapGestureRecognizerFollower];
    self.lblFollower.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerFollowing = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingTapped)];
    tapGestureRecognizerFollowing.numberOfTapsRequired = 1;
    [self.lblFollowing addGestureRecognizer:tapGestureRecognizerFollowing];
    self.lblFollowing.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerNumberFollower = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followerTapped)];
    tapGestureRecognizerNumberFollower.numberOfTapsRequired = 1;
    [self.lblNumberFollower addGestureRecognizer:tapGestureRecognizerNumberFollower];
    self.lblNumberFollower.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerNumberFollowing  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingTapped)];
    tapGestureRecognizerNumberFollowing.numberOfTapsRequired = 1;
    [self.lblNumberFollowing addGestureRecognizer:tapGestureRecognizerNumberFollowing];
    self.lblNumberFollowing.userInteractionEnabled = YES;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self getData];
    [self getTimelineUser];
    self.navigationController.hidesBarsOnSwipe = NO;
}
-(void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
}
-(void)setFont{
    
    [_lblUsername setFont: [_lblUsername.font fontWithSize:[Utils fontSizeBig]]];
    [_lblDescription setFont: [_lblDescription.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblFollowing setFont: [_lblFollowing.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblFollower setFont: [_lblFollower.font fontWithSize:[Utils fontSizeNormal]]];
    
}
-(void)heightHeader:(NSString *)name description:(NSString*) des{
    UILabel* lblUsername = self.lblUsername;
    UILabel* lblDescription = self.lblDescription;
    lblUsername.lineBreakMode = NSLineBreakByWordWrapping;
    lblUsername.numberOfLines = 0;
    lblDescription.lineBreakMode = NSLineBreakByWordWrapping;
    lblUsername.text = name;
    lblDescription.text = des;
    [lblUsername sizeToFit];
    [lblDescription sizeToFit];
    self.tableView.tableHeaderView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.width * 122 / 320 + self.imgAvatarUser.frame.size.height / 2 + self.lblUsername.frame.size.height + 28);
}
-(void)setData{
    self.lblNumberFollower.text = [NSString stringWithFormat:@"%ld" , (long)_userProfile.number_follower];
    self.lblNumberFollowing.text = [NSString stringWithFormat: @"%ld" , (long)_userProfile.number_following];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , _userProfile.avatar];
    NSString *linkBanner = [NSString stringWithFormat:@"%@" , _userProfile.banner];
    self.lblUsername.text = _userProfile.name;
    [self.imgAvatarUser sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
    [self.imgBanner sd_setImageWithURL:[NSURL URLWithString:[linkBanner stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    if(_userProfile.is_follow == YES){
        [_btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
    }else [_btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
    [self.headerTableview setNeedsDisplay];
}
-(void)getTimelineUser{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/timeline" , self.userID]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                         fromJSONDictionary:responseObject
                                                      error:nil];
        NSLog(@"%@" , responseObject);
        if(self.object.code == 1){
            self.results  =  [MTLJSONAdapter modelsOfClass:[UserTimeline class] fromJSONArray:self.object.result error:nil];
            [self setData];
            [self heightHeader:_userProfile.name description:@"Hi , I am an lifestyle and landscape photographer , freelance designer and programer."];
            [self.tableView reloadData];
            
        }
        else NSLog(@"%@" ,self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)getData{
    NSLog(@"%@" , self.userID);
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@" , self.userID]];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        SingleObject *object = [MTLJSONAdapter modelOfClass:[SingleObject class]
                                         fromJSONDictionary:responseObject
                                                      error:nil];
        NSLog(@"%@" , object);
        if(object.code == 1){
            _userProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            [self setData];
            [self heightHeader:_userProfile.name description:@"Hi , I am an lifestyle and landscape photographer , freelance designer and programer."];
            [self.tableView reloadData];
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)viewDidLayoutSubviews{
    self.imgAvatarUser.layer.cornerRadius = self.imgAvatarUser.frame.size.height /2 ;
    self.imgAvatarUser.layer.masksToBounds = YES;
    [self.imgAvatarUser layoutIfNeeded];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserProfileTableViewCell class])];
    if (!cell) {
        NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UserProfileTableViewCell class]) owner:nil options:nil];
        cell = [nib lastObject];
    }
    UserTimeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblUsername.text = currentTime.authorName;
    cell.lblLocation.text = [self subStringLocation:currentTime.location];
    NSDate *date = [NSDate date];
    
    cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_likes];
    cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_comment];
    long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [currentTime.created longLongValue];
    if(time/86400000 != 0){
        cell.lblTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
    }
    else if(time/3600000 != 0){
        cell.lblTime.text = [NSString stringWithFormat:@"%lld giờ trước" , time/3600000];
    }
    else if(time/60000 != 0){
        cell.lblTime.text = [NSString stringWithFormat:@"%lld phút trước" , time/60000];
        
    }
    else {
        cell.lblTime.text = [NSString stringWithFormat:@"Vừa xong"];
    }
    cell.contentView.userInteractionEnabled = true;
    if(currentTime.is_like){
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:currentTime.image_groups[0]
                                                   error:nil];
        if(group.photos.count > 0){
            NSString *url = group.photos[0];
            NSString *match = @".vn/";
            NSString *pre;
            NSString *last;
            NSScanner *scanner = [NSScanner scannerWithString:url];
            [scanner scanUpToString:match intoString:&pre];
            [scanner scanString:match intoString:nil];
            last = [url substringFromIndex:scanner.scanLocation];
            NSString *newUrl = [NSString stringWithFormat:@"http://easygo.com.vn/api/image/resize?path=%@&width=%d&height=%d" ,last ,(int)[UIScreen mainScreen].bounds.size.width,(int)[UIScreen mainScreen].bounds.size.width * 7 /8];
            [cell.image sd_setImageWithURL:[NSURL URLWithString:newUrl]
                          placeholderImage:[UIImage imageNamed:@"1"]];

        }
        cell.lblTitle.text = currentTime.title;
        group.title = [group.title stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        cell.lblContent.text = group.title;
    }
    [cell setNeedsLayout];
    cell.cellIndex = indexPath.section;
    cell.delegate = self;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.results.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0f;
}
#pragma mark - Utils

-(NSString *)subStringLocation:(NSString *)location{
    int dem = 0;
    NSMutableArray *array = [@[] mutableCopy];
    
    [location enumerateSubstringsInRange:NSMakeRange(0, [location length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        [array addObject:substring];
    }] ;
    NSCountedSet * set = [[NSCountedSet alloc] initWithArray:array];
    
    for (NSString *nucleobase in @[@","]){
        dem =  [set countForObject:nucleobase];
        NSLog(@"%@: %lu", nucleobase, (unsigned long)dem);
    }
    
    while(dem > 1){
        NSString *match = @",";
        NSString *pre;
        NSString *last;
        NSScanner *scanner = [NSScanner scannerWithString:location];
        [scanner scanUpToString:match intoString:&pre];
        [scanner scanString:match intoString:nil];
        last = [location substringFromIndex:scanner.scanLocation];
        NSMutableString *mu = [NSMutableString stringWithString:last];
        location = last;
        NSMutableArray *array = [@[] mutableCopy];
        
        [mu enumerateSubstringsInRange:NSMakeRange(0, [mu length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
            [array addObject:substring];
        }] ;
        NSCountedSet * set = [[NSCountedSet alloc] initWithArray:array];
        
        for (NSString *nucleobase in @[@","]){
            dem =  [set countForObject:nucleobase];
            NSLog(@"%@: %lu", nucleobase, (unsigned long)dem);
        }
    }
    return location;
}

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self getTimelineUser];
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
    UserTimeline *lastUserTimeline =  self.results[self.results.count - 1];
    NSString *urlString =[NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/timeline?last_time=%@" , self.userID , lastUserTimeline.created];
    NSURL *URL = [NSURL URLWithString:urlString];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                             error:nil];
        NSLog(@"%@" , responseObject);
        if(self.object.code == 1){
            NSArray *array  =  [MTLJSONAdapter modelsOfClass:[UserTimeline class] fromJSONArray:self.object.result error:nil];
            for(UserTimeline *timeLine in array){
                [self.results addObject:timeLine];
            }
            [self.tableView finishLoadMore];
            [self heightHeader:_userProfile.name description:@"Hi , I am an lifestyle and landscape photographer , freelance designer and programer."];
            [self.tableView reloadData];
            
        }
        else NSLog(@"%@" ,self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}
#pragma mark - click button
- (IBAction)clickBtnFollow:(id)sender {
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(self.userProfile.is_follow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/follow",self.userID];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [_btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
//        [_btnFollow layer].cornerRadius = [self.btnFollow layer].frame.size.height / 100;
        self.userProfile.is_follow = YES;

    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/follow",self.userID];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [_btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
//        [_btnFollow layer].cornerRadius = [self.btnFollow layer].frame.size.height / 100;
        self.userProfile.is_follow = NO;
    }
}
#pragma mark - user tableview cell delegate
-(void)clickBtnLike:(NSInteger)cellIndex id:(id)sender{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UserTimeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    UserProfileTableViewCell *cell = (UserProfileTableViewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if(timeline.is_like == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/like",timeline.iD];
        [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        timeline.is_like = YES;
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%d" , timeline.number_likes + 1];
        timeline.number_likes ++;
        self.results[cellIndex] = timeline;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/unlike",timeline.iD];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        timeline.is_like = NO;
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%d" , timeline.number_likes - 1];
        timeline.number_likes --;
        self.results[cellIndex] = timeline;
    }

}
-(void)clickBtnShare:(NSInteger)cellIndex{
    UserTimeline *timeline = self.results[cellIndex];
    NSString *string = [NSString stringWithFormat:@"http://easygo.com.vn/#/post-detail/%@",timeline.iD];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:string];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];

}
-(void)clickBtnComment:(NSInteger)cellIndex{
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    UserTimeline *timeline = self.results[cellIndex];
    vc.idPost = timeline.iD;
    vc.isClickComment = YES;
    [self.navigationController pushViewController:vc animated:YES];

}
-(void)clickBtnReport:(NSInteger)cellIndex{
    ReportView *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ReportView class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 200 /568);
    detailView.delegate = self;
    cellReport = cellIndex;
    alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:detailView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
    [alertView setTintColor:[UIColor whiteColor]];
    [alertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
    [alertView setDelegate:self];
    
    // You may use a Block, rather than a delegate.
    [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
        [alertView close];
    }];
    alertView.parentView.userInteractionEnabled = YES;
    [alertView setUseMotionEffects:true];
    [alertView show];
    
    
}
-(void)clickDongY:(NSString *)content{
    Timeline *timeline = self.results[cellReport];
    NSDictionary *params = @{
                             @"reason":content
                             };
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat:@"http://easygo.com.vn/api/post/%@/report" , timeline.idPost];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [alertView close];
    cellReport = -1;
}
-(void)clickHuy{
    [alertView close];
    cellReport = -1;
}
-(void)contentTapped:(NSInteger)cellIndex{
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    UserTimeline *timeline = self.results[cellIndex];
    vc.idPost = timeline.iD;
    [self.navigationController pushViewController:vc animated:YES];

}
#pragma mark  - label tapped
-(void)followerTapped{
    NSString *userID = self.userID;
    FollowViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
    vc.userID = userID;
    vc.isFollower = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)followingTapped{
    NSString *userID = self.userID;
    FollowViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
    vc.userID = userID;
    vc.isFollower = NO;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
