//
//  SearchTableViewCell.h
//  Gogo
//
//  Created by Thuong on 9/24/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblNamePost;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;

@end
