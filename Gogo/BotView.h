//
//  BotView.h
//  Gogo
//
//  Created by Thuong on 9/10/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol BotViewDelegate <NSObject>
-(void)clickBtnDangBaiViet;
@end
@interface BotView : UITableViewCell
- (IBAction)clickBtnDangBaiViet:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnDangBaiViet;
@property (weak, nonatomic) id <BotViewDelegate> delegate;
@end
