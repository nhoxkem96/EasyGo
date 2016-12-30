//
//  CommentCell.h
//  Gogo
//
//  Created by Thuong on 9/22/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCommentAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentName;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentContent;
@property (weak, nonatomic) IBOutlet UILabel *lblCommentTime;

@end
