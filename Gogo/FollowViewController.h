//
//  FollowViewController.h
//  Gogo
//
//  Created by Thuong on 11/3/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSString *userID;
@property BOOL isFollower;
@end
