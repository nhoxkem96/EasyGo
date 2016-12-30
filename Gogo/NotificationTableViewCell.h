//
//  NotificationTableViewCell.h
//  Gogo
//
//  Created by Thuong on 8/28/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblNotification;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserAvatar;
@property (weak, nonatomic) IBOutlet UIButton *btnCheck;
- (IBAction)clickBtnCheck:(id)sender;
@property BOOL check;
@end
