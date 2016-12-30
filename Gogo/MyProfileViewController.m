//
//  MyProfileViewController.m
//  Gogo
//
//  Created by Thuong on 11/5/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import "MyProfileViewController.h"
@import GoogleMaps;
#import "TimelineInMapTableViewCell.h"
#import "AFNetworking.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Object.h"
#import "UserTimeline.h"
#import "ImageGroup.h"
#import "TimeLineInMapWithoutContent.h"
#import <QuartzCore/CALayer.h>
#import "ViewController.h"
#import "UserProfileTableViewCell.h"
#import "FollowViewController.h"
#import "ELCImagePickerHeader.h"
#import "Cloudinary.h"
#import "ReportView.h"
#import "CustomIOSAlertView.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ChangeNameView.h"
#import "SingleObject.h"
#define ZOOM 100000
@import Mapbox;
@interface MyProfileViewController ()<UITableViewDelegate , UITableViewDataSource,UserProfileTableViewCellDelegate,MGLMapViewDelegate,ELCImagePickerControllerDelegate,CLUploaderDelegate,ReportViewDelegate,CustomIOSAlertViewDelegate>{
    BOOL checkShowMap;
    CustomIOSAlertView *alertView;
    NSInteger cellReport;
    CustomIOSAlertView *alertViewChangeName;
}
@property (nonatomic, strong) IBOutlet GMSCameraPosition *camera;
@property (weak, nonatomic) IBOutlet MGLMapView *mapView;
@property (nonatomic, strong) IBOutlet GMSMarker *marker;
@property (nonatomic, strong) IBOutlet MGLPointAnnotation *hello;
@end

@implementation MyProfileViewController
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
     [self.navigationController setNavigationBarHidden:NO animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self getData];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    checkShowMap = true;
    self.mapView.delegate = self;
    self.mapView.styleURL = [MGLStyle lightStyleURLWithVersion:9];
    _hello = [[MGLPointAnnotation alloc] init];
    _hello.coordinate = CLLocationCoordinate2DMake(38.894368, -77.036487);
    [self.mapView addAnnotation:_hello];
    CLLocationCoordinate2D centerCoordinate = CLLocationCoordinate2DMake(38.894368, -77.036487);
    [self.mapView setCenterCoordinate:centerCoordinate zoomLevel:5 animated:YES];
    
    [self getTimelineUser];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.imgAvatar layoutIfNeeded];
    [self setFont];
    [self addTapgesture];
    _heightHeaderView.constant = 50 + [UIScreen mainScreen].bounds.size.width * 7 / 32 + 20;
    
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
            [self setData];
            
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)setData{
    self.lblUserName.text = _myProfile.name;
    self.lblNumberFollower.text = [NSString stringWithFormat:@"%ld" , (long)_myProfile.number_follower];
    self.lblNumberFollowing.text = [NSString stringWithFormat: @"%ld" , (long)_myProfile.number_following];
    NSString *linkAvatar = [NSString stringWithFormat:@"%@" , _myProfile.avatar];
    [self.imgAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                      placeholderImage:[UIImage imageNamed:@"1"]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 300;
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
}
-(void)viewDidLayoutSubviews{
    self.imgAvatar.layer.cornerRadius = self.imgAvatar.frame.size.height /2 ;
    self.imgAvatar.layer.masksToBounds = YES;
    [self.imgAvatar layoutIfNeeded];
}
-(void)setFont{
    
    [_lblUserName setFont: [_lblUserName.font fontWithSize:[Utils fontSizeBig]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblNumberFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblFollowing setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_lblFollower setFont: [_lblNumberFollower.font fontWithSize:[Utils fontSizeNormal]]];
    [_btnBanDo.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
    [_btnBaiViet.titleLabel setFont:[UIFont systemFontOfSize:[Utils fontSizeBig]]];
}
- (void)showMap
{
    [_btnBanDo setTitleColor:[UIColor colorWithRed:(22/255.f) green:(79/255.f) blue:(122/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnBaiViet setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    
    _vPickerPosition.constant = 0;
}
- (void)showPost
{
    [_btnBanDo setTitleColor:[UIColor colorWithRed:(0/255.f) green:(0/255.f) blue:(0/255.f) alpha:1.0] forState:UIControlStateNormal];
    [_btnBaiViet setTitleColor:[UIColor colorWithRed:(22/255.f) green:(79/255.f) blue:(122/255.f) alpha:1.0] forState:UIControlStateNormal];
    _vPickerPosition.constant = self.vBaiViet.frame.origin.x;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)getTimelineUser{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];
    
    NSURL *URL = [NSURL URLWithString:[NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/timeline" , userID]];
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager GET:URL.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object = [MTLJSONAdapter modelOfClass:[Object class]
                                   fromJSONDictionary:responseObject
                                                error:nil];
        if(object.code == 1){
            self.results  =  [MTLJSONAdapter modelsOfClass:[UserTimeline class] fromJSONArray:object.result error:nil];
            self.tableView.scrollEnabled = YES;
            if(self.results.count == 0){
                self.tableView.scrollEnabled = NO;
            }
            [self.tableView reloadData];
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(checkShowMap){
        if(indexPath.row % 2 == 0){
            TimelineInMapTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TimelineInMapTableViewCell class])];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TimelineInMapTableViewCell class]) owner:nil options:nil];
                cell = [nib lastObject];
            }
            UserTimeline *currentTime = self.results[indexPath.row/2];
            if(indexPath.row == 0){
                CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([currentTime.lat floatValue], [currentTime.lon floatValue]);
                
                MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:coordinate
                                                                        fromDistance:ZOOM
                                                                               pitch:0
                                                                             heading:0];
                
                [self.mapView flyToCamera:camera completionHandler:nil];
                [self.mapView flyToCamera:camera withDuration:2.0 completionHandler:nil];
                _hello.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
                [self.mapView addAnnotation:_hello];
            }
            
            
            NSString *linkAvatar = [NSString stringWithFormat:@"%@" , currentTime.authorAvatar];
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
                    NSString *newUrl = [NSString stringWithFormat:@"http://easygo.com.vn/api/image/resize?path=%@&width=%d&height=%d" ,last ,(int)[UIScreen mainScreen].bounds.size.width *3/16,(int)[UIScreen mainScreen].bounds.size.width * 5 /32];
                    [cell.image sd_setImageWithURL:[NSURL URLWithString:newUrl]
                                  placeholderImage:[UIImage imageNamed:@"1"]];
                    
                }
                cell.lblTitle.text = currentTime.title;
                group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
                cell.lblContent.text = group.title;
            }
            CALayer *cellImageLayer = cell.vIndex.layer;
            [cellImageLayer setCornerRadius:cell.vIndex.frame.size.height / 2];
            [cellImageLayer setMasksToBounds:YES];
            cell.userInteractionEnabled = YES;
            return cell;
            
        }
        else{
            TimeLineInMapWithoutContent *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TimeLineInMapWithoutContent class])];
            if (!cell) {
                NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TimeLineInMapWithoutContent class]) owner:nil options:nil];
                cell = [nib lastObject];
            }
            cell.userInteractionEnabled = NO;
            return cell;
        }
        
    }
    else{
        UserProfileTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UserProfileTableViewCell class])];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([UserProfileTableViewCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        UserTimeline *currentTime = self.results[indexPath.row];
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
            group.title = [group.title stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"];
            cell.lblContent.text = group.title;
        }
        [cell setNeedsLayout];
        cell.cellIndex = indexPath.section;
        cell.delegate = self;
        return cell;
        
        
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(checkShowMap){
        return self.results.count * 2;
    }
    return self.results.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(checkShowMap){
        if(indexPath.row % 2 == 0){
            return UITableViewAutomaticDimension;
        }
        else if(indexPath.row ==  self.results.count * 2 - 1){
            return [UIScreen mainScreen].bounds.size.height;
        }
        else return [UIScreen mainScreen].bounds.size.height * 200 / 568;
    }
    else
        return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewAutomaticDimension;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"ViewController"];
    UserTimeline *timeline;
    if(checkShowMap){
        timeline = self.results[indexPath.row/2];
    }
    else timeline = self.results[indexPath.row];
    vc.idPost = timeline.iD;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma  mark - scroll
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSArray *listOfVisibleCells = _tableView.visibleCells;
    for(UITableViewCell *cell in listOfVisibleCells){
        if([cell isKindOfClass:[TimelineInMapTableViewCell class]]){
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            UserTimeline *currentTime = self.results[indexPath.row/2];
            /* Smooth fade out */
            TimelineInMapTableViewCell *cellTimeline = (TimelineInMapTableViewCell*)cell;
            if (scrollView.contentOffset.y + 64 + [UIScreen mainScreen].bounds.size.height * 55/568 > (cell.frame.origin.y )) {
                if([currentTime.lat floatValue] != 0 && [currentTime.lon floatValue] != 0){
                    cellTimeline.vIndex.backgroundColor = [UIColor whiteColor];
                    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([currentTime.lat floatValue], [currentTime.lon floatValue]);
                    MGLMapCamera *camera = [MGLMapCamera cameraLookingAtCenterCoordinate:coordinate
                                                                            fromDistance:ZOOM
                                                                                   pitch:0
                                                                                 heading:0];
                    
                    dispatch_async (dispatch_get_main_queue(), ^{
                        [self.mapView flyToCamera:camera withDuration:2.0 completionHandler:nil];
                        _hello.coordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
                        [self.mapView addAnnotation:_hello];
                    });
                }
            }
            else{
                cellTimeline.vIndex.backgroundColor = [UIColor colorWithRed:15/255.0 green:148/255.0f blue:46/255.0f alpha:1.0];
            }
        }
    }
    if(self.results.count > 1){
        if (scrollView.contentOffset.y == 0) {
            self.constraintTop.constant = 0;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 [self.view layoutIfNeeded]; // Called on parent view
                                 self.navigationController.navigationBarHidden = NO;
                                 self.vHeader.hidden = NO;
                             }];
            
        }
        else{
            self.constraintTop.constant = -( 50 + [UIScreen mainScreen].bounds.size.width * 7 / 32 + 20) + 20;
            [UIView animateWithDuration:0.5
                             animations:^{
                                 
                                 [self.view layoutIfNeeded]; // Called on parent view
                                 self.navigationController.navigationBarHidden = YES;
                                 self.vHeader.hidden = YES;
                             }];
            
        }
    }
    
}
- (MGLAnnotationView *)mapView:(MGLMapView *)mapView viewForAnnotation:(id <MGLAnnotation>)annotation {
    return nil;
}
- (BOOL)mapView:(MGLMapView *)mapView annotationCanShowCallout:(id <MGLAnnotation>)annotation {
    return YES;
}
#pragma  mark - clickBtn

- (IBAction)clickBtnBanDo:(id)sender {
    checkShowMap = true;
    [self showMap];
    self.mapView.hidden = NO;
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView reloadData];
}

- (IBAction)clickBtnBaiViet:(id)sender {
    checkShowMap = false;
    [self showPost];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.mapView.hidden = YES;
    [self.tableView reloadData];
}
#pragma mark - substrig
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
#pragma mark - add tapgesture
-(void)addTapgesture{
    UITapGestureRecognizer *tapGestureRecognizerAvatar = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(avatarTapped)];
    tapGestureRecognizerAvatar.numberOfTapsRequired = 1;
    [_imgAvatar addGestureRecognizer:tapGestureRecognizerAvatar];
    _imgAvatar.userInteractionEnabled = YES;
    
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
    [self.lblFollowing addGestureRecognizer:tapGestureRecognizerNumberFollower];
    self.lblFollowing.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerNumberFollowing  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(followingTapped)];
    tapGestureRecognizerNumberFollowing.numberOfTapsRequired = 1;
    [self.lblFollowing addGestureRecognizer:tapGestureRecognizerNumberFollowing];
    self.lblFollowing.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGestureRecognizerUsername  = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(usernameTapped)];
    tapGestureRecognizerUsername.numberOfTapsRequired = 1;
    [self.lblUserName addGestureRecognizer:tapGestureRecognizerUsername];
    self.lblUserName.userInteractionEnabled = YES;
}
-(void)customIOS7dialogButtonTouchUpInside:(id)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(buttonIndex == 0){
        NSString *access_token = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"access_token"];
        NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
        NSString *name = [[NSUserDefaults standardUserDefaults]
                          stringForKey:@"nameToChange"];
        NSDictionary *params = @{
                                 @"new_name":name
                                 };
        NSURL * url = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/user/update-name"];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        [manager PUT:url.absoluteString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@" ,responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@" , error);
        }];
        self.lblUserName.text = name;
        [self nameChanged:name];
    }
}
-(void)usernameTapped{
    ChangeNameView *changeNameView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ChangeNameView class]) owner:nil options:nil] objectAtIndex:0];
    changeNameView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 50 /568);
    
    //    changeNameView.delegate = self;
    //    cellReport = cellIndex;
    alertView = [[CustomIOSAlertView alloc] init];
    [alertView setContainerView:changeNameView];
    [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"Xác nhận",nil]];
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

-(void)followerTapped{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];
    FollowViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
    vc.userID = userID;
    vc.isFollower = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
-(void)followingTapped{
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];
    FollowViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"FollowViewController"];
    vc.userID = userID;
    vc.isFollower = NO;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)avatarTapped{
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 1; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = YES; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}


#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [[UIImage alloc]init];
    
    NSDate *date = [[NSDate alloc] init];
    NSString *public_id = [NSString stringWithFormat:@"Documents/%lld" , [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                NSDate *date = [[NSDate alloc] init];
                NSString *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Documents/%lld.jpg", [@(floor([date timeIntervalSince1970] * 1000)) longLongValue]]];
                [UIImageJPEGRepresentation(image, 1.0) writeToFile:jpgPath atomically:YES];
                NSURL *url = [[NSURL alloc]initFileURLWithPath:jpgPath];
                AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
                
                [manager POST:@"http:easygo.com.vn/api/files/upload" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                    [formData appendPartWithFileURL:url name:@"file" error:nil];
                } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                    NSLog(@"%@" , responseObject);
                    NSString *urlAvatar = [responseObject objectForKey:@"path"];
                    [self requestChangeAvatar:urlAvatar];
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    NSLog(@"Error: %@", error);
                }];
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    [self changeImage:image];
    self.imgAvatar.image = image;
    
}
-(void)requestChangeAvatar:(NSString *)url{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    
    NSDictionary *params = @{
                             @"new_avatar":url
                             };
    NSURL * urlUpdateAvatar = [[NSURL alloc]initWithString:@"http://easygo.com.vn/api/user/update-avatar"];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [manager PUT:urlUpdateAvatar.absoluteString parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@" ,responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@" , error);
    }];
}
-(void)changeImage:(UIImage *)image{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeAvatar:)]) {
        [self.delegate changeAvatar:image];
    }
}
-(void)nameChanged:(NSString *)name{
    if (self.delegate && [self.delegate respondsToSelector:@selector(changeName:)]) {
        [self.delegate changeName:name];
    }
}
- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
@end
