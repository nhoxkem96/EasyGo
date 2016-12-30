//
//  HomeTableViewCellWithoutImage.h
//  Gogo
//
//  Created by Thuong on 10/31/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeTableViewCellWithoutImage : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;

@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)clickBtnLike:(id)sender;
- (IBAction)clickBtnComment:(id)sender;
- (IBAction)clickBtnShare:(id)sender;
- (IBAction)clickBtnReport:(id)sender;
@property BOOL isLike;
@end
