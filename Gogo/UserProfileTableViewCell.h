//
//  UserProfileTableViewCell.h
//  Gogo
//
//  Created by Thuong on 9/18/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol UserProfileTableViewCellDelegate <NSObject>
-(void)clickBtnComment:(NSInteger) cellIndex;
-(void)contentTapped:(NSInteger) cellIndex;
-(void)titleTapped:(NSInteger) cellIndex;
-(void)clickBtnLike:(NSInteger) cellIndex id:(id)sender;
-(void)clickBtnShare:(NSInteger)cellIndex;
-(void)clickBtnReport:(NSInteger)cellIndex;
@end
@interface UserProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblUsername;
@property (weak, nonatomic) IBOutlet UILabel *lblLocation;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)clickBtnLike:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnComment;
- (IBAction)clickBtnComment:(id)sender;
- (IBAction)clickBtnShare:(id)sender;
- (IBAction)clickBtnReport:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;
@property (weak, nonatomic) IBOutlet UIView *vTop;
@property (weak, nonatomic) IBOutlet UIView *vUtils;
@property (weak, nonatomic) IBOutlet UIView *vBot;
@property (weak, nonatomic) IBOutlet UIView *vStatus;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@property NSInteger cellIndex;
@property (weak, nonatomic) id <UserProfileTableViewCellDelegate> delegate;
@end
