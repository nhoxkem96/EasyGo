//
//  MyProfileTableViewCell.h
//  Gogo
//
//  Created by Thuong on 9/8/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KIImagePager.h"
#import "Profile.h"
#import "UserTimeline.h"
@protocol MyProfileTableViewCellDelegate <NSObject>
-(void)clickBtnComment:(NSInteger) cellIndex;
-(void)contentTapped:(NSInteger) cellIndex;
-(void)titleTapped:(NSInteger) cellIndex;
-(void)clickBtnLike:(NSInteger) cellIndex id:(id)sender;
@end
@interface MyProfileTableViewCell : UITableViewCell<KIImagePagerDelegate, KIImagePagerDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UIView *vTop;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UIView *vStatus;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;

@property (weak, nonatomic) IBOutlet UIButton *btnShare;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UIButton *btnReport;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIView *vUtils;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
@property (weak, nonatomic) IBOutlet UIView *vBot;
@property IBOutlet KIImagePager *imagePager;
@property (nonatomic, strong) NSMutableArray *imageArray;
@property (weak, nonatomic) IBOutlet UIButton *clickBtnComment;
- (IBAction)clickBtnLike:(id)sender;
- (IBAction)clickBtnComment:(id)sender;

- (void)displayImages:(NSMutableArray *)imageArray;
@property NSInteger cellIndex;
@property (weak, nonatomic) id <MyProfileTableViewCellDelegate> delegate;
@end
