//
//  MyProfileViewController.h
//  Gogo
//
//  Created by Thuong on 11/5/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
@protocol MyProfileDelegate <NSObject>
-(void)changeAvatar:(UIImage*)image;
-(void)changeName:(NSString*)name;
@end
@interface MyProfileViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *vMap;
@property NSMutableArray *results;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollowing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraintTop;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollower;
@property (weak, nonatomic) IBOutlet UILabel *lblFollower;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UIView *vHeader;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightHeaderView;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *vPickerPosition;
@property (weak, nonatomic) IBOutlet UIButton *btnBanDo;
@property (weak, nonatomic) IBOutlet UIButton *btnBaiViet;
@property (weak, nonatomic) IBOutlet UIView *vBaiViet;
@property (weak, nonatomic) IBOutlet UIView *vPicker;
- (IBAction)clickBtnBanDo:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vBanDo;
- (IBAction)clickBtnBaiViet:(id)sender;
@property  Profile *myProfile;
@property (weak, nonatomic) id <MyProfileDelegate> delegate;
@end
