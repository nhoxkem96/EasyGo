//
//  UserProfileViewController.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Profile.h"
#import "UserTimeline.h"
@interface UserProfileViewController : UIViewController<UITableViewDataSource , UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imgBanner;
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatarUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollowing;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollower;
@property (weak, nonatomic) IBOutlet UILabel *lblFollowing;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
- (IBAction)clickBtnFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *headerTableview;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblFollower;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property  Profile *userProfile;
@property NSString *userID;
@end
