//
//  MoreViewController.h
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utils.h"
#import "Profile.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GooglePlus/GooglePlus.h>

@interface MoreViewController : UIViewController <UISearchBarDelegate >
@property (weak, nonatomic) IBOutlet UIView *vUser;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;

@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
- (IBAction)clickBtnUser:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *vFollowing;
@property (weak, nonatomic) IBOutlet UIView *vFollower;
@property Profile *myProfile;
@property (weak, nonatomic) IBOutlet UIView *vLogout;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblFollower;
- (IBAction)clickBtnRaoVat:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblLogout;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *btnRaoVat;
@property (weak, nonatomic) IBOutlet UIView *vClassfied;

@property UISearchBar *searchBar;
@end
