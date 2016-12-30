//
//  BottomCell.h
//  Gogo
//
//  Created by Thuong on 8/31/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BottomCellDelegate <NSObject>
- (void)clickBtnLike;
-(void)clickBtnShare;
-(void)clickBtnReport;
@end
@interface BottomCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *btnLike;
- (IBAction)clickBtnLike:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *clickBtnComment;
@property (weak, nonatomic) IBOutlet UIButton *clickBtnShare;
@property (weak, nonatomic) IBOutlet UIButton *clickBtnReport;
- (IBAction)clickBtnComment:(id)sender;
- (IBAction)clickBtnShare:(id)sender;
- (IBAction)clickBtnReport:(id)sender;
@property BOOL isLike;
@property (weak, nonatomic) id <BottomCellDelegate> delegate;
@end
