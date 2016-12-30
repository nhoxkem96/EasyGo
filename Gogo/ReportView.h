//
//  ReportView.h
//  Gogo
//
//  Created by Thuong on 10/30/16.
//  Copyright © 2016 Thuong. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ReportViewDelegate <NSObject>
-(void)clickDongY:(NSString*)content;
-(void)clickHuy;
@end
@interface ReportView : UIView<UITextViewDelegate>
- (IBAction)clickBtnDongY:(id)sender;
- (IBAction)clickBtnHuyBo:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *txtContent;
@property (weak, nonatomic) IBOutlet UIButton *btnDongY;
@property (weak, nonatomic) IBOutlet UIButton *btnHuy;
@property (weak, nonatomic) id <ReportViewDelegate> delegate;
@end
