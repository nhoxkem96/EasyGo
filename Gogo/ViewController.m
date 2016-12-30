//
//  ViewController.m
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import "ViewController.h"
#import "AFNetworking.h"
#import "SingleObject.h"
#import "Object.h"
#import "Comment.h"
#import "CommentCell.h"
#import "THChatInput.h"
#import "Profile.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "LoginViewController.h"
#import "MWPhotoBrowser.h"
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "ReportView.h"
#import "CustomIOSAlertView.h"
#import "EditPost.h"
#import "EditPostViewController.h"
@interface ViewController ()<SliceImageDelegate , HeaderCellDelegate , BottomCellDelegate,THChatInputDelegate,LoginViewControllerDelegate,MWPhotoBrowserDelegate , ReportViewDelegate,CustomIOSAlertViewDelegate,EditPostDelegate,UpdatePostDelegate>{
    CGPoint contentOffset;
     CustomIOSAlertView *alertView;
    CustomIOSAlertView *editAlertView;
}
@property NSInteger numberCell;
@property (nonatomic) UITapGestureRecognizer *tapRecognizer;
@property (strong, nonatomic) IBOutlet THChatInput *chatInput;
@property NSString *userAvatar;
@property NSString *userName;
@property int numberData;
@property NSMutableArray *photos;
@property NSMutableArray *thumbs;
@property int index;
@property (strong, nonatomic) IBOutlet UIView *emojiInputView;
@end

@implementation ViewController
- (void)viewDidLoad {
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSLog(@"%@" , access_token);
    _numberData = 0;
    if(access_token.length < 1){
        LoginViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"LoginViewController"];
        [self.navigationController pushViewController:vc animated:YES];
    }
    [self getComment];
    [self getData];
    UITapGestureRecognizer *tapper = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedView:)];
    [self.view addGestureRecognizer:tapper];
    self.arrayComment = [[NSMutableArray alloc]init];
    NSLog(@"%ld" , (long)_numberCell);
    self.tableView.allowsSelection = NO;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.navigationItem.backBarButtonItem setTitle:@""];
    [self getUserInfo];
    [self setChatInput:nil];
    [self setEmojiInputView:nil];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    self.navigationController.navigationBar.topItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                                         initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.estimatedRowHeight = 1000.0f;
    self.arrayImage = [[NSMutableArray alloc]init];
}

-(void)dismissViewController{
    [self getData];
    [self getUserInfo];
    [self getComment];
}
-(void)getUserInfo{
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
            Profile *myProfile =  [MTLJSONAdapter modelOfClass:[Profile class]
                                    fromJSONDictionary:responseObject
                                                 error:nil];
            NSString *linkAvatar = [NSString stringWithFormat:@"%@" , myProfile.avatar];
            self.userAvatar = linkAvatar;
            self.userName = myProfile.name;
            UIImageView *myImageView = (UIImageView *)[self.view viewWithTag:990];
            
            [myImageView sd_setImageWithURL:[NSURL URLWithString:linkAvatar]
                              placeholderImage:[UIImage imageNamed:@"1"]
                                     completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                     }];
            
            
        }
        else NSLog(@"%@" ,object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];

}
- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    return NO;
}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [_chatInput resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - THChatInputDelegate
- (void)chat:(THChatInput*)input sendWasPressed:(NSString*)text
{
    NSLog(@"%@" , text);
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    NSDictionary *params = @{
                             @"content":text
                             };
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/comment/%@",_idPost];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"JSON: %@", responseObject);
        Comment *comment = [[Comment alloc]init];
        comment.authorAvatar = self.userAvatar;
        comment.authorName = self.userName;
        comment.content = text;
        comment.commentID = @"dsadsadasdas";
        NSDate *date = [NSDate date];
        comment.created = [NSNumber numberWithLongLong:[@(floor([date timeIntervalSince1970] * 1000)) longLongValue]];
//
        [self.arrayComment addObject:comment];
        self.detailPost.number_comment++;

        _numberCell = 4 + 2 * self.detailPost.image_groups.count + self.arrayComment.count;
        [self.tableView reloadData];
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    UITextView *textView = (UITextView *)[self.view viewWithTag:991];
    textView.text = @"";
    [textView resignFirstResponder];
    
    if ([self.delegate respondsToSelector:@selector(commentPostDetail:)]) {
        [self.delegate commentPostDetail:_cellIndex];
    }
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
     [self scrollToCursorForTextView:textView];
}

- (void)chatShowEmojiInput:(THChatInput*)input
{
    _chatInput.textView.inputView = _chatInput.textView.inputView == nil ? _emojiInputView : nil;
    
    [_chatInput.textView reloadInputViews];
}
- (void)tappedView:(UITapGestureRecognizer*)tapper
{
    [_chatInput resignFirstResponder];
    UITextView *textView = (UITextView *)[self.view viewWithTag:991];
    [textView resignFirstResponder];
}
#pragma mark - TableView Datasource
-(void)getData{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSLog(@"%@" , _idPost);
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@",self.idPost];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
        SingleObject *object= [MTLJSONAdapter modelOfClass:[SingleObject class]
                                  fromJSONDictionary:responseObject
                                               error:nil];
        if(object.code == 1){
            self.detailPost = [MTLJSONAdapter modelOfClass:[Timeline class]
                                        fromJSONDictionary:object.result
                                                     error:nil];

            _numberCell = 4 + 2 * self.detailPost.image_groups.count + self.arrayComment.count;
            _numberData++;
            if (self.delegate && [self.delegate respondsToSelector:@selector(updatePost:post:)]) {
                [self.delegate updatePost:_cellIndex post:self.detailPost];
            }
            if(_numberData >= 2){
                [self.tableView reloadData];
                
                if(_isClickComment == YES){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:_numberCell-1 inSection:0];
                        [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:NO];
                    });
                }
            }
        }
        NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
-(void)getComment{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/comment/%@",self.idPost];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Object *object= [MTLJSONAdapter modelOfClass:[Object class]
                                        fromJSONDictionary:responseObject
                                                     error:nil];
        NSLog(@"%@" , responseObject);
        NSLog(@"result: %@" , object.result);
        if(object.code == 1){
            NSArray *comments = [MTLJSONAdapter modelsOfClass:[Comment class] fromJSONArray:object.result error:nil];
            int tmp = 0;
            for (Comment *comment in comments) {
                [self.arrayComment addObject:comment];
                tmp++;
                
            }
            
            _numberCell = 4 + 2 * self.detailPost.image_groups.count + self.arrayComment.count;
            NSLog(@"%ld" , (long)_numberCell);
            _numberData++;
            NSLog(@"%@" , self.arrayComment);
            if(_numberData >= 2){
                NSLog(@"number data: %d" , _numberData);
                [self.tableView reloadData];
                if(_isClickComment == YES){
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:_numberCell-1 inSection:0];
                        
                        [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                    });
                }
            }
        }

        NSLog(@"%@" , object.message);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return _numberCell;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
{
        if (indexPath.row == 0) {
        HeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HeaderCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([HeaderCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
                NSString *linkAvatar = [NSString stringWithFormat:@"%@" , self.detailPost.authorAvatar];
        
        [cell.imvUser sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                          placeholderImage:[UIImage imageNamed:@"1"]];
        cell.lblUserName.text = self.detailPost.authorName;
        cell.lblAddress.text = [self subStringLocation:self.detailPost.location];
        cell.isFollow = _detailPost.is_follow;
        UIButton *btnFollow = (UIButton *)[self.view viewWithTag:998];
        if(cell.isFollow){
            [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
            [btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            [[btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        }
        else{
            [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
            [btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
            [[btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        }
        return cell;
    } else if (indexPath.row == 1) {
        TextCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        
        cell.lblTitle.text = self.detailPost.title;
        [cell.lblTitle sizeToFit];
        return cell;
    }else if(indexPath.row % 2 == 0 && indexPath.row != 0 && indexPath.row < (2 + 2 * self.detailPost.image_groups.count)){
        TextContent *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([TextContent class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([TextContent class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        long index = (indexPath.row - 2)/2;
        
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                                          fromJSONDictionary:self.detailPost.image_groups[index]
                                                                       error:nil];

        NSLog(@"%@" , group.title);
         group.title = [group.title stringByReplacingOccurrencesOfString:@"<br>" withString:@"\n"];
        [cell.lblContent setText:group.title];
        return cell;
    }
    
    else if (indexPath.row != 1 && indexPath.row < (2 + 2 * self.detailPost.image_groups.count) && indexPath.row%2 !=0 ) {
        SliceImageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SliceImageCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([SliceImageCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        long index = (indexPath.row - 3) / 2;
        
        cell.cellIndex = index;
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:self.detailPost.image_groups[index]
                                                   error:nil];
        NSMutableArray *photos = [[NSMutableArray alloc]init];
        for(NSString *url in group.photos){
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
        [cell displayImages:photos];
        if(self.commentID.length > 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            });
        }
        float random = rand()/(float)RAND_MAX;
        cell.timeSlice = random + 2.5;
        return cell;
    } else if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count)) {
        DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([DetailCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([DetailCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        NSDate *date = [NSDate date];
        long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [_detailPost.time_created longLongValue];
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
        cell.lblNumberLike.text = [NSString stringWithFormat:@"%ld" , (long)self.detailPost.number_like];
        cell.lblNumberComment.text = [NSString stringWithFormat:@"%ld" , (long)self.detailPost.number_comment];
        
        return cell;
    }else if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count) + 1) {
        BottomCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BottomCell class])];
        
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([BottomCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        cell.delegate = self;
        cell.isLike = _detailPost.is_like;
        if(cell.isLike){
            [cell.btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
        }else [cell.btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
        return cell;
    }
    else {
        CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CommentCell class])];
        if (!cell) {
            NSArray *nib = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([CommentCell class]) owner:nil options:nil];
            cell = [nib lastObject];
        }
        [cell.contentView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [cell.contentView.layer setBorderWidth:0.3f];
        Comment *comment = self.arrayComment[indexPath.row - 4 - 2 * self.detailPost.image_groups.count];
        NSString *linkAvatar = [NSString stringWithFormat:@"%@" , comment.authorAvatar];
        [cell.imgCommentAvatar sd_setImageWithURL:[NSURL URLWithString:[linkAvatar stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]
                        placeholderImage:[UIImage imageNamed:@"1"]];
        cell.lblCommentName.text = comment.authorName;
        cell.lblCommentContent.text = comment.content;
        NSDate *date = [NSDate date];
        long long time =  [@(floor([date timeIntervalSince1970] * 1000)) longLongValue] - [comment.created longLongValue];
        NSLog(@"fuck: %@" , comment.commentID);
        if(time/86400000 != 0){
            cell.lblCommentTime.text = [NSString stringWithFormat:@"%lld ngày trước" , time/86400000];
        }
        else if(time/3600000 != 0){
            cell.lblCommentTime.text = [NSString stringWithFormat:@"%lld giờ trước" , time/3600000];
        }
        else if(time/60000 != 0){
            cell.lblCommentTime.text = [NSString stringWithFormat:@"%lld phút trước" , time/60000];
            
        }
        else {
            cell.lblCommentTime.text = [NSString stringWithFormat:@"Vừa xong"];
        }
        if(self.commentID.length > 1){
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            });
        }
        if([comment.commentID caseInsensitiveCompare:self.commentID] == NSOrderedSame){
//            NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
//            [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSIndexPath *rowIndexPath = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
                [self.tableView scrollToRowAtIndexPath:rowIndexPath atScrollPosition:UITableViewScrollPositionMiddle animated:NO];
                self.commentID = @"ghfghfghfhg";
            });
        }
        return cell;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - TableView Delegate
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if (indexPath.row == 0) {
        return [UIScreen mainScreen].bounds.size.width / 4;
    } if (indexPath.row == 1) {
        return UITableViewAutomaticDimension;
    }if(indexPath.row % 2 == 0 && indexPath.row != 0 && indexPath.row <(2 + 2 * self.detailPost.image_groups.count)){
        return UITableViewAutomaticDimension;
    }
    if (indexPath.row != 1 && indexPath.row <(2 + 2 * self.detailPost.image_groups.count) && indexPath.row%2!=0 ) {
        long index = (indexPath.row - 3) / 2;
        ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                      fromJSONDictionary:self.detailPost.image_groups[index]
                                                   error:nil];
        if(group.photos.count == 0){
            return 0;
        }
        else return self.view.frame.size.width * 7 / 8;
        
    } if (indexPath.row == (2 + 2 * self.detailPost.image_groups.count)) {
        return [UIScreen mainScreen].bounds.size.width* 3 / 32;
    } if(indexPath.row == (2 + 2 * self.detailPost.image_groups.count) + 1){
        return [UIScreen mainScreen].bounds.size.width / 8;
    }
    else {
        return UITableViewAutomaticDimension;
    }
}
#pragma mark - SliceImage delegate
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index atCellIndex:(NSInteger)cellIndex{
    ImageGroup *group = [MTLJSONAdapter modelOfClass:[ImageGroup class]
                                  fromJSONDictionary:self.detailPost.image_groups[cellIndex]
                                               error:nil];
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for(NSString *url in group.photos){
        NSMutableString *mu = [NSMutableString stringWithString:url];
        [photos addObject:mu];
    }
    NSLog(@"%@" , photos);
    self.thumbs = [[NSMutableArray alloc]init];
    self.photos = [[NSMutableArray alloc]init];
    for(int i = 0; i < photos.count ; i++){
        [_photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photos[i]]]];
        [_thumbs addObject:[MWPhoto photoWithURL:[NSURL URLWithString:photos[i]]]];
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
-(void)didSelectedImage:(id)sender atIndex:(NSUInteger)index{
}
#pragma  mark - click button
-(void)clickBtnFollow{
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UIButton *btnFollow = (UIButton *)[self.view viewWithTag:998];
    if(self.detailPost.is_follow == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/follow",self.detailPost.authorID];
        [manager GET:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [btnFollow setTitle:@"Unfollow" forState:UIControlStateNormal];
        btnFollow.layer.cornerRadius;
        [btnFollow setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [[btnFollow layer] setBorderColor:[UIColor darkGrayColor].CGColor];
        self.detailPost.is_follow = YES;
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/user/%@/follow",self.detailPost.authorID];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        [btnFollow setTitle:@"Follow" forState:UIControlStateNormal];
        [btnFollow setTitleColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1] forState:UIControlStateNormal];
        [[btnFollow layer] setBorderColor:[UIColor colorWithRed:74/255.0f green:138/255.0f blue:200/255.0f alpha:1].CGColor];
        self.detailPost.is_follow = NO;
    }
}
-(void)clickBtnShare{
    NSString *string = [NSString stringWithFormat:@"http://easygo.com.vn/#/post-detail/%@",_detailPost.idPost];
    FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:string];
    [FBSDKShareDialog showFromViewController:self
                                 withContent:content
                                    delegate:nil];
}
-(void)clickBtnReport{
    ReportView *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([ReportView class]) owner:nil options:nil] objectAtIndex:0];
    detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 200 /568);
    detailView.delegate = self;
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
    NSDictionary *params = @{
                             @"reason":content
                             };
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
    [manager.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSString *url = [NSString stringWithFormat:@"http://easygo.com.vn/api/post/%@/report" , self.detailPost.idPost];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSLog(@"%@" , responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [alertView close];
    
}
-(void)clickHuy{
    [alertView close];
}
-(void)clickBtnLike{
    
    NSString *access_token = [[NSUserDefaults standardUserDefaults]
                              stringForKey:@"access_token"];
    NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
    UIButton *btnLike = (UIButton *)[self.view viewWithTag:999];
    if(self.detailPost.is_like == NO){
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/like",self.detailPost.idPost];
        [manager POST:url parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            NSLog(@"JSON: %@", responseObject);
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        self.detailPost.is_like = YES;
        self.detailPost.number_like++;
        [btnLike setImage:[UIImage imageNamed:@"liked"] forState:UIControlStateNormal];
    }
    else{
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@/unlike",self.detailPost.idPost];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        self.detailPost.is_like = NO;
        self.detailPost.number_like--;
        [btnLike setImage:[UIImage imageNamed:@"like"] forState:UIControlStateNormal];
    }
//    [self.tableView reloadData];
    
    [UIView setAnimationsEnabled:NO];
//    CGPoint contentOffset = self.tableView.contentOffset;
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    [self.tableView.layer removeAllAnimations];
    self.tableView.contentOffset = contentOffset;
    [UIView setAnimationsEnabled:YES];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(clickBtnLikePostDetail:)]) {
        [self.delegate clickBtnLikePostDetail:_cellIndex];
        
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    contentOffset = self.tableView.contentOffset;
}
#pragma mark -
- (void)keyboardWillShow:(NSNotification*)aNotification {
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, kbSize.height, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
}

- (void)keyboardWillHide:(NSNotification*)aNotification {
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.35];
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(self.tableView.contentInset.top, 0.0, 0.0, 0.0);
    self.tableView.contentInset = contentInsets;
    self.tableView.scrollIndicatorInsets = contentInsets;
    [UIView commitAnimations];
}
- (void)scrollToCursorForTextView: (UITextView*)textView {
    
    CGRect cursorRect = [textView caretRectForPosition:textView.selectedTextRange.start];
    
    cursorRect = [self.tableView convertRect:cursorRect fromView:textView];
    
    if (![self rectVisible:cursorRect]) {
        cursorRect.size.height += 8; // To add some space underneath the cursor
        [self.tableView scrollRectToVisible:cursorRect animated:YES];
    }
}
- (BOOL)rectVisible: (CGRect)rect {
    CGRect visibleRect;
    visibleRect.origin = self.tableView.contentOffset;
    visibleRect.origin.y += self.tableView.contentInset.top;
    visibleRect.size = self.tableView.bounds.size;
    visibleRect.size.height -= self.tableView.contentInset.top + self.tableView.contentInset.bottom;
    
    return CGRectContainsRect(visibleRect, rect);
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
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear: (BOOL)animated
{
    [super viewWillDisappear:animated];
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
#pragma mark - click button bar
-(void)editPost{
    
}
#pragma mark - editpost delegate
-(void)clickBtnCancel{
    [editAlertView close];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0)
    {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
        [self.navigationController popViewControllerAnimated:YES];
        NSString *access_token = [[NSUserDefaults standardUserDefaults]
                                  stringForKey:@"access_token"];
        NSString *string = [NSString stringWithFormat:@"access_token %@" , access_token];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        [manager.requestSerializer setValue:string forHTTPHeaderField:@"Authorization"];
        NSString *url = [NSString stringWithFormat:@"http:easygo.com.vn/api/post/%@",_idPost];
        [manager DELETE:url parameters:nil success:^(NSURLSessionTask *task , id responseObject){
            NSLog(@"%@" , responseObject);
        }failure:^(NSURLSessionTask *operation, NSError *error){
            NSLog(@"%@" , error);
        }];
        if (self.delegate && [self.delegate respondsToSelector:@selector(deletePost:)]) {
            [self.delegate deletePost:_cellIndex];
        }
    }
}
-(void)clickBtnDeletePost{
    [editAlertView close];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Bạn có muốn xóa bài viết này không!"
                                                    message:@""
                                                   delegate:self
                                          cancelButtonTitle:@"Đồng ý"
                                          otherButtonTitles:@"Hủy",nil];
    

    [alert show];
}
-(void)updateComplete{
    _numberCell = 0;
    [self getData];
    
}
-(void)clickBtnEditPost{
    EditPostViewController *vc = [[Utils mainStoryboard] instantiateViewControllerWithIdentifier:@"EditPostViewController"];
    vc.detailPost = self.detailPost;
    vc.delegate = self;
    [editAlertView close];
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (IBAction)clickRightBarButton:(id)sender {
    NSString *userID = [[NSUserDefaults standardUserDefaults]
                        stringForKey:@"userID"];
    if([self.detailPost.authorID caseInsensitiveCompare:userID] == NSOrderedSame){
        EditPost *detailView = [[[NSBundle mainBundle]loadNibNamed:NSStringFromClass([EditPost class]) owner:nil options:nil] objectAtIndex:0];
        detailView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height * 120 /568);
        detailView.delegate = self;
        editAlertView = [[CustomIOSAlertView alloc] init];
        [editAlertView setContainerView:detailView];
        [editAlertView setButtonTitles:[NSMutableArray arrayWithObjects:nil]];
        [editAlertView setTintColor:[UIColor whiteColor]];
        [editAlertView setBackgroundColor:[UIColor colorWithRed:31 green:137 blue:255 alpha:1]];
        [editAlertView setDelegate:self];
        
        // You may use a Block, rather than a delegate.
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            NSLog(@"Block: Button at position %d is clicked on alertView %d.", buttonIndex, (int)[alertView tag]);
            [alertView close];
        }];
        editAlertView.parentView.userInteractionEnabled = YES;
        [editAlertView setUseMotionEffects:true];
        [editAlertView show];
    }
   
}
@end
