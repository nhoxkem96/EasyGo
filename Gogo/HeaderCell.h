//
//  HeaderCell.h
//  Demo
//
//  Created by Trung Đức on 8/27/16.
//  Copyright © 2016 Trung Đức. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HeaderCellDelegate <NSObject>
- (void)clickBtnFollow;
@end
@interface HeaderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imvUser;
@property (weak, nonatomic) IBOutlet UILabel *lblUserName;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;
@property (weak, nonatomic) IBOutlet UIButton *btnFollow;
- (IBAction)clickBtnFollow:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *lblNumberFollow;
@property BOOL isFollow;
- (void)displayUser:(NSString *)userName image:(NSString *)imageName address:(NSString *)address followCount:(NSString *)followCount;
@property (weak, nonatomic) id <HeaderCellDelegate> delegate;
@end
