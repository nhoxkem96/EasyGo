//
//  TimelineInMapTableViewCell.h
//  Gogo
//
//  Created by Thuong on 11/5/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TimelineInMapTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *vIndex;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblContent;
@property (weak, nonatomic) IBOutlet UILabel *lblTime;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberComment;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberLike;
@property (weak, nonatomic) IBOutlet UIView *vContent;

@end
