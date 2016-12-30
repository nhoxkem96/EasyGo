//
//  HomeViewController.m
//  Gogo
//
//  Created by Thuong on 8/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "HomeViewController.h"
#import "HomeTableviewCell.h"
#import <TLYShyNavBar/TLYShyNavBarManager.h>
#import "LoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UITableView+DragLoad.h"
#import "UserProfileViewController.h"
#import "MWPhotoBrowser.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "SearchViewController.h"
#import "CustomIOSAlertView.h"
#import "ReportView.h"
#import "JSONModelLib.h"
#import "JSONModel.h"
#import "HomeTableViewCellWithoutImage.h"
@interface HomeViewController ()<HomeTableviewCellDelegate, LoginViewControllerDelegate,MWPhotoBrowserDelegate ,CustomIOSAlertViewDelegate,ReportViewDelegate,UITableViewDragLoadDelegate,PostDetailDelegate>{
    CustomIOSAlertView *alertView;
    NSInteger cellReport;
    UIView *vStatus;
}
@property (nonatomic) CGFloat previousScrollViewYOffset;
@property LoginViewController *vc;
@property id numberNotiNotSeen;
@property NSMutableArray *photos;
@property NSMutableArray *thumbs;
@end
@implementation HomeViewController
-(instancetype)init {
    if ((self = [super init])) {
        self.results = [NSMutableArray array];
    }
    return self;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];

//    self.shyNavBarManager.scrollView = self.homeTableview;
    self.arrayImageRandom = [[NSMutableArray alloc]init];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.homeTableview.rowHeight = UITableViewAutomaticDimension;
    self.homeTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.extendedLayoutIncludesOpaqueBars = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self getData];
    [self.homeTableview setDragDelegate:self refreshDatePermanentKey:@"FriendList"];
    self.homeTableview.showRefreshView = YES;
    self.vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    self.vc.delegate = self;
    cellReport = -1;
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1]];
    [self initSearchBar];
    vStatus=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    vStatus.backgroundColor=[UIColor colorWithRed:66/255.0f green:100/255.0f blue:50/255.0f alpha:1];
    [self.view addSubview:vStatus];
    vStatus.hidden = YES;
    [Utils setOpenApp:YES];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}
-(void)getData{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"access token: %@" ,access_token);
    NSURL *URL = [NSURL URLWithString:@"http:easygo.com.vn/api/timeline"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(access_token.length > 1){
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    }
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                             error:nil];
        if(self.object.code == 1){
            self.results = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
            NSLog(@"abvc %@" , self.object.result);
            for(Timeline *currentTime in self.results){
                NSMutableArray *arrayAllImage = [[NSMutableArray alloc]init];
                NSMutableArray *arrayImageDisplay = [[NSMutableArray alloc]init];
                for(int j = 0 ; j < currentTime.image_groups.count ; j++){
                    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                                  fromJSONDictionary:currentTime.image_groups[j]
                                                               error:nil];
                    for(int i = 0 ; i < group.photos.count ; i++){
                        [arrayAllImage addObject:group.photos[i]];
                    }
                }
                if(arrayAllImage.count > 8){
                    NSMutableArray* arrayCheck = [[NSMutableArray alloc] init];
                    for(int i = 0 ; i < arrayAllImage.count; i++){
                        [arrayCheck addObject:[NSNumber numberWithBool:NO]];
                    }
                    while(arrayImageDisplay.count <= 7){
                        int r = arc4random() % arrayAllImage.count;
                        if(![[arrayCheck objectAtIndex:r] boolValue]){
                            [arrayImageDisplay addObject:arrayAllImage[r]];
                            arrayCheck[r] = [NSNumber numberWithBool:YES];
                        }
                    }
                }else{
                    arrayImageDisplay = arrayAllImage;
                }
                
                NSMutableArray *photos = [[NSMutableArray alloc]init];
                for(NSString *url in arrayImageDisplay){
                    NSString *match = @".vn/";
                    NSString *pre;
                    NSString *last;
                    NSScanner *scanner = [NSScanner scannerWithString:url];
                    [scanner scanUpToString:match intoString:&pre];
                    [scanner scanString:match intoString:nil];
                    last = [url substringFromIndex:scanner.scanLocation];
                    NSString *newUrl = [NSString stringWithFormat:@"http://easygo.com.vn/api/image/resize?path=%@&width=%d&height=%d" ,last ,(int)[UIScreen mainScreen].bounds.size.width,(int)[UIScreen mainScreen].bounds.size.width * 7 /8];
                    [photos addObject:newUrl];
                }
                [self.arrayImageRandom addObject:photos];
            }
            [self.homeTableview finishRefresh];
            [self.homeTableview reloadData];
        }
        else NSLog(@"%@" , self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)getNoti{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/notifications?page=1"];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        _numberNotiNotSeen = [responseObject objectForKey:@"number_have_not_seen"];
        if([_numberNotiNotSeen integerValue] > 0 ){
            [[self.tabBarController.tabBar.items objectAtIndex:3] setBadgeValue:[NSString stringWithFormat:@"%@" , _numberNotiNotSeen]];
        }
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (void)initSearchBar {
    _searchBar = [[UISearchBar alloc] init];
    self.searchBar.showsCancelButton = false;
    self.searchBar.placeholder = @"Tìm kiếm thông tin địa điểm";
    self.searchBar.delegate = self;
    self.searchBar.searchBarStyle = UISearchBarStyleMinimal;
    self.navigationItem.titleView = self.searchBar;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Control datasource

#pragma mark - Drag delegate methods

- (void)dragTableDidTriggerRefresh:(UITableView *)tableView
{
    [self getData];
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
    //send load more request(generally network request) here
    NSLog(@"loadmore");
    Timeline *timeline = self.results[self.results.count - 1];
    NSString *loadMore = [NSString stringWithFormat:@"http:easygo.com.vn/api/timeline?last_time=%lld" , [timeline.time_created longLongValue]];
    NSLog(@"%@" , loadMore);
    NSURL *URL = [NSURL URLWithString:[loadMore stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    if(access_token.length > 1){
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    }
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        self.object = [MTLJSONAdapter modelOfClass:[Object class]
                                fromJSONDictionary:responseObject
                                             error:nil];
        if(self.object.code == 1){
            NSArray *more = [MTLJSONAdapter modelsOfClass:[Timeline class] fromJSONArray:self.object.result error:nil];
            for (Timeline *timeline in more) {
                [self.results addObject:timeline];
                NSMutableArray *arrayAllImage = [[NSMutableArray alloc]init];
                NSMutableArray *arrayImageDisplay = [[NSMutableArray alloc]init];
                for(int j = 0 ; j < timeline.image_groups.count ; j++){
                    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                                  fromJSONDictionary:timeline.image_groups[j]
                                                               error:nil];
                    for(int i = 0 ; i < group.photos.count ; i++){
                        [arrayAllImage addObject:group.photos[i]];
                    }
                }
                if(arrayAllImage.count > 8){
                    NSMutableArray* arrayCheck = [[NSMutableArray alloc] init];
                    for(int i = 0 ; i < arrayAllImage.count; i++){
                        [arrayCheck addObject:[NSNumber numberWithBool:NO]];
                    }
                    while(arrayImageDisplay.count <= 7){
                        int r = arc4random() % arrayAllImage.count;
                        if(![[arrayCheck objectAtIndex:r] boolValue]){
                            [arrayImageDisplay addObject:arrayAllImage[r]];
                            arrayCheck[r] = [NSNumber numberWithBool:YES];
                        }
                    }
                }else{
                    arrayImageDisplay = arrayAllImage;
                }
                
                NSMutableArray *photos = [[NSMutableArray alloc]init];
                for(NSString *url in arrayImageDisplay){
                    NSString *match = @".vn/";
                    NSString *pre;
                    NSString *last;
                    NSScanner *scanner = [NSScanner scannerWithString:url];
                    [scanner scanUpToString:match intoString:&pre];
                    [scanner scanString:match intoString:nil];
                    last = [url substringFromIndex:scanner.scanLocation];
                    NSString *newUrl = [NSString stringWithFormat:@"http://easygo.com.vn/api/image/resize?path=%@&width=%d&height=%d" ,last ,(int)[UIScreen mainScreen].bounds.size.width,(int)[UIScreen mainScreen].bounds.size.width * 7 /8];
                    [photos addObject:newUrl];
                }
                [self.arrayImageRandom addObject:photos];
            }
            [_homeTableview finishLoadMore];
            [self.homeTableview reloadData];
        }
        else NSLog(@"%@" , self.object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

//    [self performSelector:@selector(finishLoadMore) withObject:nil afterDelay:2];
}

- (void)dragTableLoadMoreCanceled:(UITableView *)tableView
{
    //cancel load more request(generally network request) here
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(finishLoadMore) object:nil];
}

#pragma  mark - tableview Cell
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    HomeTableviewCell *cell = (HomeTableviewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    NSArray *arrayImage = self.arrayImageRandom[indexPath.section];
    Timeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    [cell.imagePager removeConstraint: cell.constantImagePagerRaito];
    if(arrayImage.count > 0){
        [cell displayImages:arrayImage];
        [cell.imagePager removeConstraint: cell.constantImagePagerRaito];
        NSLayoutConstraint *constraint =[NSLayoutConstraint
                                         constraintWithItem:cell.imagePager
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cell.imagePager
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:8/7
                                         constant:0.0f];
        [cell.imagePager addConstraint:constraint];
        cell.imagePager.hidden = NO;

    }else{
       
        [cell.imagePager removeConstraint: cell.constantImagePagerRaito];
        NSLayoutConstraint *constraint =[NSLayoutConstraint
                                         constraintWithItem:cell.imagePager
                                         attribute:NSLayoutAttributeWidth
                                         relatedBy:NSLayoutRelationEqual
                                         toItem:cell.imagePager
                                         attribute:NSLayoutAttributeHeight
                                         multiplier:0
                                         constant:0.0f];
        [cell.imagePager addConstraint:constraint];
        cell.imagePager.hidden = YES;
    }

    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
    [cell.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    cell.lblUserName.text = currentTime.authorName;
    cell.lblLocation.text = [self subStringLocation:currentTime.location];
    NSString * timestamp = [NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970] * 1000];
    NSLog(@"%@", timestamp);
    cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_like];
    cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)currentTime.number_comment];
    cell.lblNumberFollow.text = [NSString stringWithFormat:@"%@" , currentTime.number_follow];
    double timestamp1 = [[NSDate date] timeIntervalSince1970];
    int64_t timeInMilisInt64 = (int64_t)(timestamp1*1000);
    long long time =  timeInMilisInt64 - [currentTime.time_created longLongValue];
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
    cell.delegate = self;
    cell.cellIndex = indexPath.section;
    cell.contentView.userInteractionEnabled = true;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lblTitle.text = currentTime.title;
    cell.isLike = currentTime.is_like;
    cell.isFollow = currentTime.is_follow;
    float random = rand()/(float)RAND_MAX;
    cell.timeSlice  = random + 2.5;
    if(cell.isFollow){
        [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
    }
    else{
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
    }
    if(cell.isLike){
        [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    
    NSLog(@"%lu" , (unsigned long)currentTime.image_groups.count);
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:currentTime.image_groups[0]
                                                   error:nil];
        group.title = [group.title stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        NSLog(@"%@" , self.arrayImageRandom[indexPath.section]);
        cell.lblTitle.text = currentTime.title;
        cell.lblContent.text = group.title;
        
    }
    
    return cell;
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.results.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    HomeTableviewCell *cell = (HomeTableviewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    NSArray *arrayImage = self.arrayImageRandom[indexPath.section];
    Timeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    [cell.imagePager removeConstraint: cell.constantImagePagerRaito];
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:currentTime.image_groups[0]
                                                   error:nil];
        
        NSLog(@"%@" , self.arrayImageRandom[indexPath.section]);
        cell.lblTitle.text = currentTime.title;
        cell.lblContent.text = group.title;
    }
    if(!(arrayImage.count > 0)){
        float a = [UIScreen mainScreen].bounds.size.width * 3 / 16 + [UIScreen mainScreen].bounds.size.width * 3 / 32 + [UIScreen mainScreen].bounds.size.width /8 + [self getLabelHeight:cell.lblTitle] + [self getLabelHeight:cell.lblContent] + 45;
        NSLog(@"content: %f" , [self getLabelHeight:cell.lblContent]);
        NSLog(@"title: %f" , [self getLabelHeight:cell.lblTitle]);
        NSLog(@"dfuck : %f" , [UIScreen mainScreen].bounds.size.width * 3 / 16 + [UIScreen mainScreen].bounds.size.width * 3 / 32 + [UIScreen mainScreen].bounds.size.width /8 + [self getLabelHeight:cell.lblTitle] + [self getLabelHeight:cell.lblContent] + 45);
        return a;
        
    }
    else return UITableViewAutomaticDimension;

}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeTableviewCell *cell = (HomeTableviewCell*)[tableView dequeueReusableCellWithIdentifier:@"HomeTableViewCell"];
    NSArray *arrayImage = self.arrayImageRandom[indexPath.section];
    Timeline *currentTime = self.results[indexPath.section];
    self.timeline = currentTime;
    [cell.imagePager removeConstraint: cell.constantImagePagerRaito];
    if(currentTime.image_groups.count > 0){
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:currentTime.image_groups[0]
                                                   error:nil];
        
        NSLog(@"%@" , self.arrayImageRandom[indexPath.section]);
        cell.lblTitle.text = currentTime.title;
        cell.lblContent.text = group.title;
        group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
    }
    if(!(arrayImage.count > 0)){
        float a = [UIScreen mainScreen].bounds.size.width * 3 / 16 + [UIScreen mainScreen].bounds.size.width * 3 / 32 + [UIScreen mainScreen].bounds.size.width /8 + [self getLabelHeight:cell.lblTitle] + [self getLabelHeight:cell.lblContent] + 45;
        NSLog(@"dfuck : %f" , [UIScreen mainScreen].bounds.size.width * 3 / 16 + [UIScreen mainScreen].bounds.size.width * 3 / 32 + [UIScreen mainScreen].bounds.size.width /8 + [self getLabelHeight:cell.lblTitle] + [self getLabelHeight:cell.lblContent] + 45);
        return a;
        
    }
    else return UITableViewAutomaticDimension;
}
- (CGFloat)getLabelHeight:(UILabel*)label
{
    CGSize constraint = CGSizeMake(label.frame.size.width, CGFLOAT_MAX);
    CGSize size;
    
    NSStringDrawingContext *context = [[NSStringDrawingContext alloc] init];
    CGSize boundingBox = [label.text boundingRectWithSize:constraint
                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                               attributes:@{NSFontAttributeName:label.font}
                                                  context:context].size;
    
    size = CGSizeMake(ceil(boundingBox.width), ceil(boundingBox.height));
    
    return size.height;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0){
        return 0;
    }
    else return 10.0f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

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
#pragma mark - label tapped
-(void)contentTapped:(NSInteger)cellIndex{
    vStatus.hidden = YES;
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(access_token.length > 1){
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.idPost = timeline.idPost;
        vc.cellIndex = cellIndex;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        [self presentViewController:self.vc animated:NO completion:nil];
    }

}
-(void)usernameTapped:(NSInteger)cellIndex{
    vStatus.hidden = YES;
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(access_token.length > 1){
        UserProfileViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"UserProfileViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.userID = timeline.authorID;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else [self presentViewController:self.vc animated:NO completion:nil];;
     
}
-(void)titleTapped:(NSInteger)cellIndex{
    vStatus.hidden = YES;
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(access_token.length > 1){
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.idPost = timeline.idPost;
        vc.cellIndex = cellIndex;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
    else{
        [self presentViewController:self.vc animated:NO completion:nil];
    }

}
#pragma mark - 
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atSection:(NSInteger)cellIndex{
    
    NSArray *arrayPhotos = self.arrayImageRandom[cellIndex];
    self.thumbs = [[NSMutableArray alloc]init];
    self.photos = [[NSMutableArray alloc]init];
    for(int i = 0; i < arrayPhotos.count ; i++){
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:arrayPhotos[i]]]];
        [_thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:arrayPhotos[i]]]];
    }
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = YES;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.zoomPhotosToFill = YES;
    browser.alwaysShowControls = NO;
    browser.enableGrid = YES;
    browser.startOnGrid = NO;
    browser.autoPlayOnAppear = NO;
    [browser setCurrentPhotoIndex:index];
    
    // Present
    [self.navigationController pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
}
-(void)clickBtnComment:(NSInteger)cellIndex{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    if(access_token.length > 1){
        ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
        Timeline *timeline = self.results[cellIndex];
        vc.idPost = timeline.idPost;
        vc.isClickComment = YES;
        vc.cellIndex = cellIndex;
        vc.delegate = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
    else{
//         [self.navigationController pushViewController:self.vc animated:YES];
        [self presentViewController:self.vc animated:NO completion:nil];
    }
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
    cellReport = -1;
    [alertView close];

}
-(void)clickHuy{
    [alertView close];
    cellReport = -1;
}
-(void)clickBtnLike:(NSInteger)cellIndex id:(id)sender{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSLog(@"%@" , access_token);
    Timeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    HomeTableviewCell *cell = (HomeTableviewCell *)[_homeTableview cellForRowAtIndexPath:indexPath];
    if(access_token.length > 1){
        
        if(cell.isLike == NO){
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
            NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/like",timeline.idPost];
            [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            } failure:^(NSURLSessionTask *operation, NSError *error) {
                NSLog(@"Error: %@", error);
            }];
            cell.isLike = YES;
            [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
            timeline.is_like = YES;
            cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , timeline.number_like + 1];
            timeline.number_like ++;
            self.results[cellIndex] = timeline;
        }
        else{
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
            [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
            NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/unlike",timeline.idPost];
            [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
                NSLog(@"%@" , responseObject);
            }failure:^(NSURLSessionTask *operation, NSError *error){
                NSLog(@"%@" , error);
            }];
            cell.isLike = NO;
            [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
            timeline.is_like = NO;
            cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , timeline.number_like - 1];
            timeline.number_like --;
            self.results[cellIndex] = timeline;
        }

    }
    else{
        
        [self presentViewController:self.vc animated:NO completion:nil];
    }
}
-(void)clickBtnShare:(NSInteger)cellIndex{
    Timeline *timeline = self.results[cellIndex];
    
    NSString *string = [NSString stringWithFormat:@"http://easygo.com.vn/#/post-detail/%@",timeline.idPost];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:string];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}
-(void)clickBtnFollow:(NSInteger)cellIndex{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    Timeline *timeline = self.results[cellIndex];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    HomeTableviewCell *cell = (HomeTableviewCell *)[_homeTableview cellForRowAtIndexPath:indexPath];
    if(cell.isFollow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/follow",timeline.idPost];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        cell.isFollow = YES;
        [cell.btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        int x = [timeline.number_follow intValue];
        cell.lblNumberFollow.text = [NSString stringWithFormat:@"%d" , x + 1];
        timeline.number_follow = [NSNumber numberWithInt:x+1];
        [cell.btnFollow layer].cornerRadius = 3;
        timeline.is_follow = YES;
        self.results[cellIndex] = timeline;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/unfollow",timeline.idPost];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        cell.isFollow = NO;
        [cell.btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [cell.btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[cell.btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        [cell.btnFollow layer].cornerRadius = 3;
        timeline.is_follow = NO;
        int x = [timeline.number_follow intValue];
        cell.lblNumberFollow.text = [NSString stringWithFormat:@"%d" , x - 1];
        timeline.number_follow = [NSNumber numberWithInt:x-1];
        self.results[cellIndex] = timeline;

    }
}
#pragma mark - 
-(void)dismissViewController{
    [self.results removeAllObjects];
    [self getData];
    [self getNoti];
}
#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}
- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - searchBar delegate
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [self initSearchBar];
    [self.tabBarController setSelectedIndex:1];
    UINavigationController *firstTabNC = [[self.tabBarController viewControllers] objectAtIndex:1];
    SearchViewController *vc = (SearchViewController*)[[firstTabNC viewControllers] objectAtIndex:0];
    [vc setEditSearchBar];
}

#pragma mark - ComposePost delegate
-(void)resetData{
    [self.results removeAllObjects];
    [self.arrayImageRandom removeAllObjects];
    [self getData];
    
    if(self.results.count > 0){
        [self.homeTableview setContentOffset:CGPointZero animated:YES];
    }
    
    
}
-(void)postComplete{
    [self.homeTableview scrollsToTop];
    [self getData];
}
#pragma  mark - app delegate
-(void)updateFCM:(NSString *)oldFCM new:(NSString *)newFCM;{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSDictionary *params = @{
                             @"fcm_old":oldFCM,
                             @"fcm_new":newFCM
                             };
    NSURL * url = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/fcm"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager PUT:url.absoluteString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@" ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@" , error);
    }];
}
-(void)sendFCMThenLogin:(NSString *)token{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSDictionary *params = @{
                             @"fcm_id":token
                             };
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager POST:@"http://easygo.com.vn/api/fcm" parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
-(void)login{
    [self presentViewController:self.vc animated:NO completion:nil];
}
#pragma mark - Postdetail delegate
-(void)clickBtnLikePostDetail:(NSInteger)cellIndex{
    Timeline *timeline = self.results[cellIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    HomeTableviewCell *cell = (HomeTableviewCell *)[_homeTableview cellForRowAtIndexPath:indexPath];
    if(cell.isLike == NO){
        timeline.is_like = YES;
        timeline.number_like ++;
        self.results[cellIndex] = timeline;
        CGPoint contentOffset = self.homeTableview.contentOffset;
        [UIView setAnimationsEnabled:NO];
        contentOffset = self.homeTableview.contentOffset;
        [self.homeTableview beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.homeTableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.homeTableview endUpdates];
        [self.homeTableview.layer removeAllAnimations];
        self.homeTableview.contentOffset = contentOffset;
        [UIView setAnimationsEnabled:YES];

    }
    else{
        timeline.is_like = NO;
        timeline.number_like --;
        self.results[cellIndex] = timeline;
        CGPoint contentOffset = self.homeTableview.contentOffset;
        [UIView setAnimationsEnabled:NO];
        contentOffset = self.homeTableview.contentOffset;
        [self.homeTableview beginUpdates];
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
        NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
        [self.homeTableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
        [self.homeTableview endUpdates];
        [self.homeTableview.layer removeAllAnimations];
        self.homeTableview.contentOffset = contentOffset;
        [UIView setAnimationsEnabled:YES];
    }

}
-(void)commentPostDetail:(NSInteger)cellIndex{
    Timeline *timeline = self.results[cellIndex];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:cellIndex];
    timeline.number_comment ++;
    self.results[cellIndex] = timeline;
    CGPoint contentOffset = self.homeTableview.contentOffset;
    [UIView setAnimationsEnabled:NO];
    contentOffset = self.homeTableview.contentOffset;
    [self.homeTableview beginUpdates];
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath, nil];
    [self.homeTableview reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.homeTableview endUpdates];
    [self.homeTableview.layer removeAllAnimations];
    self.homeTableview.contentOffset = contentOffset;
    [UIView setAnimationsEnabled:YES];
}
-(void)deletePost:(NSInteger)cellIndex{
    [self.results removeObjectAtIndex:cellIndex];
    [self.homeTableview reloadData];
    if(self.results.count > 0){
        [self.homeTableview scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }
}
-(void)updatePost:(NSInteger)cellIndex post:(Timeline *)post{
    self.results[cellIndex] = post;
    [self.homeTableview reloadData];
}
#pragma mark - scroll delegate
-(void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                    withVelocity:(CGPoint)velocity
             targetContentOffset:(inout CGPoint *)targetContentOffset{
    if (velocity.y < 0){
        
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.navigationController setNavigationBarHidden:NO animated:YES];
            vStatus.hidden = YES;
            
            
        }];
    }
    if (velocity.y > 0){
        vStatus.hidden = NO;
        [UIView animateWithDuration:0.5 animations:^{
            
            [self.navigationController setNavigationBarHidden:YES animated:YES];
            
            
        }];
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

@end
